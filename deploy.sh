#!/bin/sh
hexo generate
cp -R public/* .deploy/clove506.github.io
cd .deploy/clove506.github.io
git add .
git commit -m “update”
git push origin master
