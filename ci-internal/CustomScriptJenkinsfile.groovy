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
    sh 'flutter channel stable'
    sh 'flutter upgrade'
}

def stages = [];

for (n in nodes) {
    stages.add(pipeline.node(n, [updateStage]))
}

//stages
pipeline.stages = [
        pipeline.parallel('', stages)
]

//run
pipeline.run()
