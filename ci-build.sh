#!/bin/bash
echo "commitid: $GITHUB_SHA" > _config-github.yml
jekyll build  --config _config.yml,_config-github.yml
if [ $? -ne 0 ]
then
  exit 1
fi
mkdir build
tar -czvf build/build.tar.gz -C _site .
cp ci-deploy.sh ./build