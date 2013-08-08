#!/bin/bash

./compile.sh

mv index.html /tmp
git checkout gh-pages
git fetch origin
git merge origin/gh-pages
mv /tmp/index.html ./

git commit -am 'regenerate'
git push origin gh-pages
git checkout master
