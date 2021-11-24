#!/usr/bin/env bash

default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@');

branches_to_die=$(git branch --no-color --merged origin/${default_branch} | grep -v '^[\* ] ${default_branch}')
echo "Branches to be deleted:"
echo $branches_to_die
echo ""
echo "Enter Y to confirm"
read -p "> " confirm

kill_branches(){
  echo $branches_to_die | xargs -n 1 git branch -D
}

[[ $confirm == "Y"  ]] && kill_branches
