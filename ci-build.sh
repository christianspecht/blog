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

# rename project pages
mv ./public/bitbucket-backup/index.html ./public/bitbucket-backup/index.php
mv ./public/missilesharp/index.html ./public/missilesharp/index.php
mv ./public/recordset-net/index.html ./public/recordset-net/index.php
mv ./public/roboshell-backup/index.html ./public/roboshell-backup/index.php
mv ./public/simpleleague/index.html ./public/simpleleague/index.php
mv ./public/tasko/index.html ./public/tasko/index.php
mv ./public/vba-helpers/index.html ./public/vba-helpers/index.php

# archive site
mkdir build
tar -czvf build/build.tar.gz -C public .
cp ci-deploy.sh ./build
