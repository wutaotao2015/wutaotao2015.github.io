#!/bin/bash
set -ev

git clone --recursive https://${GH_REF} .deploy_git
cd .deploy_git
git checkout master

cd ../
mv .deploy_git/.git/ ./public/

cd ./public
git config user.name  "wutaotao"
git config user.email "531618500@qq.com"

# add commit timestamp
git add .
git commit -m "Travis CI Auto Builder at `date +"%Y-%m-%d %H:%M"`"
git push --force --quiet "https://${Token}@${GH_REF}" master:master

# algolia content index
cd ../
export HEXO_ALGOLIA_INDEXING_KEY=36c22b899b61ecb907f3b36dca59aca9
./node_modules/.bin/hexo algolia
