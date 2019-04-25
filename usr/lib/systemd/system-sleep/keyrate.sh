#!/bin/sh

#systemd runs all executables in /usr/lib/systemd/system-sleep/, passing two arguments to each of them:

#Argument 1: either pre or post, depending on whether the machine is going to sleep or waking up
#Argument 2: suspend, hibernate or hybrid-sleep, depending on which is being invoked

case $1/$2 in
  pre/*)
    ;;
  post/*)
    $HOME/dotfiles/bin/reset_keyrate.sh
    ;;
esac
