@Library('surf-lib@flutter') // https://bitbucket.org/surfstudio/jenkins-pipeline-lib/
import ru.surfstudio.ci.pipeline.pr.PrPipelineAndroid
import ru.surfstudio.ci.stage.StageStrategy

//init
def pipeline = new PrPipelineFlutter(this)
pipeline.init()

//customization
pipeline.getStage(pipeline.INSTRUMENTATION_TEST).strategy = StageStrategy.SKIP_STAGE
pipeline.getStage(pipeline.STATIC_CODE_ANALYSIS).strategy = StageStrategy.SKIP_STAGE
//pipeline.buildGradleTask = "clean assemble"
//pipeline.androidTestBuildType = "debug"

//run
pipeline.run()
