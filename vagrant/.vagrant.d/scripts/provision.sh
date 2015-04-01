#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install screen vim git-core
#su -c "cd /home/bradclark/.dotfiles && ./setup.sh" vagrant
#su -c 'cat >> /home/bradclark/.bashrc << EOF 

## start ssh-agent
#if [ "$SSH_AUTH_SOCK" = "" -a -x /usr/bin/ssh-agent ]; then
#                eval `/usr/bin/ssh-agent`
#fi
#EOF' bradclark
