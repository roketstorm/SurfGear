#!/usr/bin/env bash

ios=ios
android=android

platform=

function build() {
    if [[ ${platform} = ${ios} ]]; then
       ./script/ios/build.sh -qa
    else
       ./script/android/build.sh -qa
    fi
}

function buildRepo() {
#    build template only todo change to modules when examples are created

    cd ./template
    build
    cd ..

    #todo uncomment in future
#    for dir in ./* ; do
#        pwd
#
#        echo ${dir}
#        cd ${dir}
#        build
#        cd ..
#    done
}


echo "Parameters" $1 $2
while [[ -n "$1" ]]; do # while loop starts

        case "$1" in

            -ios )          platform=ios
                            ;;

            -android )      platform=android
                            ;;

            esac

         shift

done

buildRepo