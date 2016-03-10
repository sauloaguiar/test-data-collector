#!/bin/bash

# Usage
# Call this script specifying three arguments
# 1. a folder name to hold test data
# 2. the path to the repo

args=("$@")
echo ${args[0]}
echo ${args[1]}
cd ${args[1]}
#$(git checkout master)
base_dir="/Users/sauloaguiar/Desktop"
git_history=($(git log --pretty=format:"%H"))
git_history_length=${#git_history[@]}

git pull origin master
git checkout master

for ((git_index=0; git_index<${git_history_length}; git_index++));
  do
    # fresh the repo to its initial state
    git pull origin master
    git checkout master

    echo ${git_history[git_index]}
    # create dir to hold test data
    mkdir -p $base_dir/${args[0]}/${git_history[git_index]}

    # checkout to the sha1
    git checkout ${git_history[git_index]}

    # find where plugins.sbt is
    plugins_sbt_path=($(find . -name plugins.sbt))
    echo ${plugins_sbt_path}
    # append the scoverage lib to the file
    echo -e '\naddSbtPlugin("org.scoverage" % "sbt-scoverage" % "1.3.5")' >> $plugins_sbt_path

    # run the test suite
    sbt clean coverage test -mem 4096

    # run scoverage report
    sbt coverageReport

    # find xml generated data
    scoverage_path=($(find . -name "scoverage-report"))
    echo ${scoverage_path}
    scoverage_path+="/scoverage.xml"

    # copy scoverage.xml file
    cp ${scoverage_path} $base_dir/${args[0]}/${git_history[git_index]}/

    # find test-reports dir
    treports_path=($(find . -name "test-reports"))

    # copy test-reports dir
    cp -vr ${treports_path} $base_dir/${args[0]}/${git_history[git_index]}/

    # store the date in a file
    echo $(git show -s --format=%ci) >> $base_dir/${args[0]}/${git_history[git_index]}/date.txt

    git checkout -- .
done
