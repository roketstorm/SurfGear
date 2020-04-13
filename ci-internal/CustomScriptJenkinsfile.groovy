@Library('surf-lib@version-3.0.0-SNAPSHOT')
// https://bitbucket.org/surfstudio/jenkins-pipeline-lib/
import ru.surfstudio.ci.pipeline.empty.EmptyScmPipeline
import ru.surfstudio.ci.stage.StageStrategy
import ru.surfstudio.ci.CommonUtil
import ru.surfstudio.ci.JarvisUtil
import ru.surfstudio.ci.NodeProvider
import ru.surfstudio.ci.Result
import java.net.URLEncoder

def encodeUrl(string) {
    URLEncoder.encode(string, "UTF-8")
}

//init
def pipeline = new EmptyScmPipeline(this)


def nodes = ['android-1', 'android-2']

pipeline.propertiesProvider = {
    return [
    ]
}

def updateStage = pipeline.stage('Upgrade') {
    pipeline.sh 'flutter channel stable'
    pipeline.sh 'flutter upgrade'
}

//stages
pipeline.stages = [
        pipeline.parallel {
            for (n in nodes) {
                pipeline.node(n) {
                    updateStage
                }
            }
        }
]

//run
pipeline.run()
