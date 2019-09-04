@Library('surf-lib@flutter') // https://bitbucket.org/surfstudio/jenkins-pipeline-lib/
import ru.surfstudio.ci.pipeline.pr.PrPipelineFlutter
import ru.surfstudio.ci.stage.StageStrategy
import ru.surfstudio.ci.CommonUtil

//init
def pipeline = new PrPipelineFlutter(this)
pipeline.init()

//customization
pipeline.getStage(pipeline.STATIC_CODE_ANALYSIS).strategy = StageStrategy.SKIP_STAGE

pipeline.buildAndroidCommand = "cd ./template ;" +
        "    flutter build apk --flavor dev;" +
        "    cd .."

pipeline.buildIOsCommand = "cd ./template ;" +
        "    flutter build ios --flavor dev;" +
        "    cd ..;"

pipeline.getStage(pipeline.BUILD_IOS).body = {
        CommonUtil.shWithRuby(this, pipeline.buildIOsCommand)
}
//run
pipeline.run()
