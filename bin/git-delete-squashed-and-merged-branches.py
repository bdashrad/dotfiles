#!/usr/bin/env python
# -*- coding: utf-8 -*-

# prereqs:
#
#     pip install pygithub
#

# usage:
#     git delete-squashed-and-merged-branches --dry-run  # won't actually delete shit
#     git delete-squashed-and-merged-branches            # probably will delete shit

# get a github personal access token and put it in ~/.githubtoken

# thanks!
# this script is a bit of a combo from:
#   danvk   https://gist.github.com/danvk/a715357444ff3c1a05c4cff730eea8e1
#   larsks  https://github.com/larsks/github-tools/blob/master/git-is-merged
#   paulirish

from glob import glob
import os.path

import sys
import github
import subprocess

yellow = '\033[93m'
reset = '\033[0m'
DRY_RUN = len(sys.argv) > 1 and sys.argv[1] == '--dry-run'


tokenpath = os.path.expanduser('~/.githubtoken')
tokenfile = open(tokenpath)
token = tokenfile.read().strip();


def get_branch_heads():
    '''Returns a map from branch name --> SHA for local branches.'''
    branch_to_sha = {}
    for path in glob('.git/refs/heads/*'):
        branch = os.path.basename(path)
        if branch == 'master': continue
        branch_to_sha[branch] = open(path).read().strip()
    return branch_to_sha


def main():
    G = github.Github(login_or_token=token)

    retval = 0
    items = get_branch_heads().items();
    print 'Looking at {} total local heads.'.format(len(items))

    for branch, sha in items:
        res = G.search_issues(sha)
        shortsha = sha[0:7]
        issue_states = [issue.state == 'closed' for issue in res]
        
        if not issue_states:
            msg = '{}{}{} ({}):\nNo PRs found. Keeping as active. \n'
            retval = 4
        elif all(issue_states):
            msg = '{}{}{} ({}):\nAll PRs are closed! 🗑 it.\n'
            retval = 0
        elif any(issue_states):
            msg = '{}{}{} ({}):\nSome (BUT not all) PRs are closed. \n'
            retval = 1
        else:
            msg = '{}{}{} ({}):\nAll PRs still open. \n'
            retval = 2

        print (msg.format(yellow, branch, reset, shortsha))

        if retval == 0:
            if DRY_RUN:
                print('Would delete local branch %s' % branch)
            else:
                subprocess.check_call(['git', 'branch', '-D', branch])

    sys.exit(retval)

if __name__ == '__main__':
    main()