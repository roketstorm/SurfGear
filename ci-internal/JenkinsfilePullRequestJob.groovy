@Library('surf-lib@flutter') // https://bitbucket.org/surfstudio/jenkins-pipeline-lib/
import ru.surfstudio.ci.pipeline.pr.PrPipelineFlutter
import ru.surfstudio.ci.stage.StageStrategy
import ru.surfstudio.ci.CommonUtil

//init
def pipeline = new PrPipelineFlutter(this)
pipeline.init()

//customization
pipeline.getStage(pipeline.STATIC_CODE_ANALYSIS).strategy = StageStrategy.SKIP_STAGE

pipeline.buildAndroidCommand = '''
### Script for run and build all of examples in packages
### No build of template - it's unnecessary

for dir in */; do
    pwd
    echo Found dir = $dir. Dive into...
    cd ${dir}
    if [ ! -f "./pubspec.yaml" ]; then
        echo "No pubspec.yaml. ${dir} is not flutter package root directory. Skipping..."
        cd ..
        continue
    fi

    if [ ! -d "./example/" ]; then
        echo "No example/ dir. ${dir} has not example!!!!!. Skipping..."
        cd ..
        continue
    fi
    pwd
    cd ./example
    flutter build apk || exit
    cd ../..
done || exit
'''

pipeline.buildIOsCommand = '' //todo build ios command

pipeline.testCommand = '''
        pwd
        for dir in */ ; do
            pwd
            echo $dir
            if [[ $dir = docs/ ]]; then
                continue
            fi
            cd ${dir}
            pwd
            flutter test
            if [ $? -eq 1 ] ; then
                echo Has errors... Exiting ...
                exit 1    
            fi
            cd ..
        done || exit 
'''

pipeline.getStage(pipeline.BUILD_IOS).strategy = StageStrategy.SKIP_STAGE

pipeline.run()
