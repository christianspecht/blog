#!/bin/bash
jekyll build
mkdir build
tar -czvf build/build.tar.gz -C _site .
cp ci-deploy.sh /build