@Library('surf-lib@version-3.0.0-SNAPSHOT')
// https://bitbucket.org/surfstudio/jenkins-pipeline-lib/

import ru.surfstudio.ci.pipeline.empty.EmptyScmPipeline
import ru.surfstudio.ci.pipeline.ScmPipeline
import ru.surfstudio.ci.JarvisUtil
import ru.surfstudio.ci.CommonUtil
import ru.surfstudio.ci.RepositoryUtil
import ru.surfstudio.ci.Result
import ru.surfstudio.ci.AbortDuplicateStrategy

//Pipeline on commit stable-branch

// Constants
def FLUTTER_PUB_ACCESS_TOKEN = "FLUTTER_PUB_ACCESS_TOKEN"
def FLUTTER_PUB_REFRESH_TOKEN = "FLUTTER_PUB_REFRESH_TOKEN"
def FLUTTER_PUB_TOKEN_ENDPOINT = "FLUTTER_PUB_TOKEN_ENDPOINT"
def FLUTTER_PUB_SCOPES = "FLUTTER_PUB_SCOPES"
def FLUTTER_PUB_EXPIRATION = "FLUTTER_PUB_EXPIRATION"

// Stage names

def CHECKOUT = 'Checkout'
def GET_DEPENDENCIES = 'Getting dependencies'
def FIND_CHANGED = 'Find changed'
def CHECK_PUBLISH_AVAILABLE = 'Check publish available'
def MIRRORING = 'Mirroring'
def CHECKS_RESULT = 'Checks Result'
def CLEAR_CHANGED = 'Clear changed'

//vars
def branchName = "stable"
def buildDescription = "stable release"

//init
def script = this
def pipeline = new EmptyScmPipeline(script)

pipeline.init()

//configuration
pipeline.node = "android"
pipeline.propertiesProvider = { initProperties(pipeline) }

pipeline.preExecuteStageBody = { stage ->
    if (stage.name != CHECKOUT) RepositoryUtil.notifyGitlabAboutStageStart(script, pipeline.repoUrl, stage.name)
}
pipeline.postExecuteStageBody = { stage ->
    if (stage.name != CHECKOUT) RepositoryUtil.notifyGitlabAboutStageFinish(script, pipeline.repoUrl, stage.name, stage.result)
}

pipeline.initializeBody = {
    CommonUtil.printInitialStageStrategies(pipeline)

    /// Данный джоб должен работать только в ветке stable, поэтому в случае
    // если было переданно неправильное имя для запуска кидаем исключение.
    // Параметр не имеет никакого смысла но нужен для триггеринга
    def branchFromParam = ''

    CommonUtil.extractValueFromEnvOrParamsAndRun(script, 'branchName_0') {
        value -> branchFromParam = value
    }

    if (branchFromParam != branchName) {
        throw new Exception("This pipeline work only on stable brunch")
    }
}

pipeline.stages = [
        pipeline.stage(CHECKOUT) {
            script.git(
                    url: pipeline.repoUrl,
                    credentialsId: pipeline.repoCredentialsId
            )
            script.sh "git checkout -B $branchName origin/$branchName"

            script.echo "Checking $RepositoryUtil.SKIP_CI_LABEL1 label in last commit message for automatic builds"
            if (RepositoryUtil.isCurrentCommitMessageContainsSkipCiLabel(script) && !CommonUtil.isJobStartedByUser(script)) {
                throw new InterruptedException("Job aborted, because it triggered automatically and last commit message contains $RepositoryUtil.SKIP_CI_LABEL1 label")
            }
            CommonUtil.abortDuplicateBuildsWithDescription(script, AbortDuplicateStrategy.ANOTHER, buildDescription)

            RepositoryUtil.saveCurrentGitCommitHash(script)
        },

        pipeline.stage(GET_DEPENDENCIES) {
            script.sh "cd tools/ci/ && pub get"
        },

        pipeline.stage(FIND_CHANGED) {
            script.sh "./tools/ci/runner/find_changed_modules --target=dev"
        },

        pipeline.stage(CHECK_PUBLISH_AVAILABLE) {
            script.sh "./tools/ci/runner/check_publish_available"
        },
        pipeline.stage(CHECKS_RESULT) {
            def checksPassed = true
            [
                    CHECK_PUBLISH_AVAILABLE,

            ].each { stageName ->
                def stageResult = pipeline.getStage(stageName).result
                checksPassed = checksPassed && (stageResult == Result.SUCCESS || stageResult == Result.NOT_BUILT)
            }

            if (!checksPassed) {
                script.error("Checks Failed")
            }
        },
        pipeline.stage(MIRRORING) {
            script.withCredentials([
                    script.string(credentialsId: FLUTTER_PUB_ACCESS_TOKEN, variable: FLUTTER_PUB_ACCESS_TOKEN ),
                    script.string(credentialsId: FLUTTER_PUB_REFRESH_TOKEN, variable: FLUTTER_PUB_REFRESH_TOKEN ),
                    script.string(credentialsId: FLUTTER_PUB_TOKEN_ENDPOINT, variable: FLUTTER_PUB_TOKEN_ENDPOINT ),
                    script.string(credentialsId: FLUTTER_PUB_SCOPES, variable: FLUTTER_PUB_SCOPES ),
                    script.string(credentialsId: FLUTTER_PUB_EXPIRATION, variable: FLUTTER_PUB_EXPIRATION ),
            ]) {
                script.sh '''if [ -z \"${FLUTTER_PUB_ACCESS_TOKEN}\" ]; then
                                echo \"Missing PUB_DEV_PUBLISH_ACCESS_TOKEN environment variable\"
                                exit 1"
                             fi
                             
                             if [ -z \"${FLUTTER_PUB_REFRESH_TOKEN}\" ]; then
                                echo \"Missing PUB_DEV_PUBLISH_REFRESH_TOKEN environment variable\"
                                exit 1 
                             fi
                        
                             if [ -z \"${FLUTTER_PUB_TOKEN_ENDPOINT}\" ]; then
                                echo \"Missing PUB_DEV_PUBLISH_TOKEN_ENDPOINT environment variable\"
                                exit 1
                             fi
                        
                              if [ -z \"${FLUTTER_PUB_EXPIRATION}\" ]; then
                                echo \"Missing PUB_DEV_PUBLISH_EXPIRATION environment variable\"
                                exit 1
                              fi
                        
                              cat <<EOF > ~/.pub-cache/credentials.json
                              {
                                \"accessToken\":\"\$(echo \"${FLUTTER_PUB_ACCESS_TOKEN}\" | base64 -d)\",
                                \"refreshToken\":\"\$(echo \"${FLUTTER_PUB_REFRESH_TOKEN}\" | base64 -d)\",
                                \"tokenEndpoint\":\"${FLUTTER_PUB_TOKEN_ENDPOINT}\",
                                \"scopes\": \"${FLUTTER_PUB_SCOPES}\",
                                \"expiration\":${FLUTTER_PUB_EXPIRATION}
                              }
                              EOF'''
                script.sh "./tools/ci/runner/publish"
            }
        },
        pipeline.stage(CLEAR_CHANGED) {
            script.sh "./tools/ci/runner/clear_changed"
        },
]

pipeline.finalizeBody = {
    def jenkinsLink = CommonUtil.getBuildUrlSlackLink(script)
    def message
    def success = Result.SUCCESS == pipeline.jobResult
    def checkoutAborted = pipeline.getStage(CHECKOUT).result == Result.ABORTED
    if (!success && !checkoutAborted) {
        def unsuccessReasons = CommonUtil.unsuccessReasonsToString(pipeline.stages)
        message = "Deploy из ветки '${branchName}' не выполнен из-за этапов: ${unsuccessReasons}. ${jenkinsLink}"
    } else {
        message = "Deploy из ветки '${branchName}' успешно выполнен. ${jenkinsLink}"
    }
    JarvisUtil.sendMessageToGroup(script, message, pipeline.repoUrl, "gitlab", success)

}

pipeline.run()

static List<Object> initProperties(ScmPipeline ctx) {
    def script = ctx.script
    return [
            initBuildDiscarder(script),
            initParameters(script)
    ]
}

def static initBuildDiscarder(script) {
    return script.buildDiscarder(
            script.logRotator(
                    artifactDaysToKeepStr: '3',
                    artifactNumToKeepStr: '10',
                    daysToKeepStr: '60',
                    numToKeepStr: '200')
    )
}

def static initParameters(script) {
    return script.parameters([
            script.string(
                    name: "branchName_0",
                    description: 'Ветка с исходным кодом')
    ])
}