#!/bin/bash

# get GitHub data
echo "[params]
commitid = '$1'
buildnumber = '$2'" > ./src/config-github.toml

# build site
rm -r public
cd src
hugo --config config.toml,config-$3.toml,config-github.toml
cd ..

if [ $? -ne 0 ]
then
  exit 1
fi

# archive site
mkdir build
tar -czvf build/build.tar.gz -C public .
cp ci-deploy.sh ./build
