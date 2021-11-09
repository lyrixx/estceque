#!/usr/bin/env bash

git diff --exit-code > /dev/null
rc=$?

if [[ $rc == 0 ]]; then
    echo "nothing changed"
    exit
fi

set -e

echo "deploying"

git remote add github "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
git pull github ${GITHUB_REF} --ff-only

git add docs/ data.csv

git config --global user.email "lyrixx@lyrixx.info"
git config --global user.name "Grégoire Pineau"
git commit -m "Update live website"
git push github HEAD:${GITHUB_REF}
