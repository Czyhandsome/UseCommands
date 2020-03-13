#!/usr/bin/env bash

function usage() {
  echo "Usage: commitAndPush <msg>"
  exit
}

# Check if it is a git repo
if [ ! -d ".git" ]; then
  echo 'Error! not a git directory'
  exit
fi

if [ -z "$1" ]; then
  usage
fi

git commit -a -m "[修改代码](${1}) $2" && git push;
