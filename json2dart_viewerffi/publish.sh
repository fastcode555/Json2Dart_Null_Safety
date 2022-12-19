#!/bin/bash

cd lib
flutter format .
cd ..

pwd
git commit -m 'execute format'
branch=$(git symbolic-ref --short -q HEAD)
git push origin $branch
flutter packages pub publish --server=https://pub.dartlang.org