#!/bin/bash
echo "commitid: $1
buildnumber: $2" > _config-github.yml
jekyll build  --config _config.yml,_config-$3.yml,_config-github.yml
if [ $? -ne 0 ]
then
  exit 1
fi
mkdir build
tar -czvf build/build.tar.gz -C _site .
cp ci-deploy.sh ./build