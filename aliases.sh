#!/bin/bash

# Neovim
if type "nvim" &> /dev/null; then
  if type "nvr" &> /dev/null; then
    function vim() {
      if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
        nvr -p --remote-wait +'set bufhidden=wipe'
      else
        nvim $argv
      fi
    }
  else
    function vim() {
      nvim $argv
    }
  fi
fi

# Set title easily
function title() {
  echo -ne "\033]0;$1\007"
}

# Color cat
if type "ccat" &> /dev/null; then
 alias cat='ccat'
fi

# Git
alias gaa='git add -A'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged --color-moved'
alias undeployed='git fetch --multiple production origin && git log production/master..origin/master'

# Use Exhuburant ctags
if [ -f "$(brew --prefix)/bin/ctags)" ]; then
 alias ctags='$(brew --prefix)/bin/ctags'
fi

# Alias some ansible commands
if type "ansible-playbook" &> /dev/null; then
  alias aplaybook='ansible-playbook'
fi

if type "ansible-vault" &> /dev/null; then
  alias avault='ansible-vault'
fi

if type "ansible-galaxy" &> /dev/null; then
  alias agalaxy='ansible-galaxy'
fi

if type "terraform" &> /dev/null; then
  alias tf='terraform'
fi

if type "hub" &> /dev/null; then
  function git() { hub $@; }
fi

# Android development
alias adb='~/Library/Android/sdk/platform-tools/adb'

# Alias some docker commands
docker_rm_images() {
  docker images --no-trunc | \
    grep "<none>" | \
    awk "{ print '$3' }" | \
    xargs docker rmi
}
alias docker_rm_containers='docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v'
alias docker_rm_volumes='docker volume ls -qf dangling=true | xargs docker volume rm'
alias docker_clean='docker_rm_images && docker_rm_containers && docker_rm_volumes'

# Alias some NPM tools
alias google='googler -n 10'

# Alias some Ruby/Bundler/Rails commands
alias be='bundle exec'
alias sandbox='rails c --sandbox'

# Alias SourceTree to open in current dir
alias sourcetree='open -a SourceTree ./'

alias :q='exit'
alias weather='curl wttr.in'

alias ll='ls -lah'

alias tmuxbase='tmux attach -t base || tmux new -s base'

# Development
alias boom="git stash && git pull --rebase && git stash pop && git add -A && git commit -m 'another one' && git push"
alias copy_prod_db='heroku pg:backups:capture -r production && heroku pg:backups:download -r production && pg_restore --verbose --clean --no-acl --no-owner -h localhost -d joydrive_dev latest.dump'
