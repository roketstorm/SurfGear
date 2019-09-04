# !/usr/bin/env bash

pwd
for dir in */ ; do
    pwd
    echo $dir
    if [[ dir = docs ]]; then
        continue
    fi
    cd ${dir}
    pwd
    flutter test
    if [ $? -eq 1 ] ; then
        
        echo Has errors... Exiting ...
        break;
    fi
    cd ..
done || exit 1

if [ $? -eq 1 ] ; then
        exit 1
fi
exit 0