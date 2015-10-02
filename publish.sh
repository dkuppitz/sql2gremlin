#!/bin/bash

./compile.sh

mkdir -p /tmp/sql2gremlin
mv index.html /tmp/sql2gremlin
cp -R assets/ /tmp/sql2gremlin
git checkout gh-pages
git fetch origin
git merge origin/gh-pages
mv /tmp/sql2gremlin/index.html ./
mv /tmp/sql2gremlin/assets/* assets/
rm -rf /tmp/sql2gremlin

git commit -am 'regenerate'
git push origin gh-pages
git checkout master
