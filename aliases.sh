#!/bin/bash

# Neovim
if type "nvim" &> /dev/null; then
  if type "nvr" &> /dev/null; then
    function vim() {
      if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
        nvr -cc tabedit --remote-wait +'set bufhidden=wipe'
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

if [[ $TERMINFO == *"kitty"* ]];  then
  function icat() {
    kitty +kitten icat "$1"
  }

  function ranger() {
    TERM=xterm-kitty command ranger $argv
  }
fi

# Set title easily
function title() {
  echo -ne "\033]0;$1\007"
}

# Color cat
if type "ccat" &> /dev/null; then
 alias cat='ccat'
fi

if type "bat" &> /dev/null; then
 alias cat='bat -p'
fi

# Git
alias gaa='git add -A'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged --color-moved'
alias undeployed='git fetch --multiple production origin && git log production/master..origin/master'

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
if [ -d "$HOME/Library/Android/sdk/platform-tools/adb" ]; then
  alias adb="~/Library/Android/sdk/platform-tools/adb"
fi

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
if type "googler" &> /dev/null; then
  alias google='googler -n 10'
fi

# Alias some Ruby/Bundler/Rails commands
alias be='bundle exec'
alias sandbox='rails c --sandbox'

# Alias some Elixir/Phoenix commands
alias imp='iex -S mix phx.server'
alias im='iex -S mix'

if type "xclip" &> /dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -o -selection clipboard'
fi

# Alias SourceTree to open in current dir
alias sourcetree='open -a SourceTree ./'

alias :q='exit'
alias weather='curl wttr.in'

alias ll='ls -lah'

alias tmuxbase='tmux attach -t base || tmux new -s base'

alias csv-diff='git diff --color-words="[^[:space:],]+" --no-index'

if type scanimage &> /dev/null; then
  # usage: scanimg test.jpg
  alias scanimg='scanimage --device="brother4:net1;dev0" --mode Color --format=jpeg --resolution=600 --batch > '
fi

# usage: copy_heroku_db production my_app_dev
if type heroku &> /dev/null; then
  function copy_heroku_db() {
    local heroku_app=$1; shift
    local local_db=$1; shift

    [[ -z $local_db ]] && echo "Please specify the local database to load into" && return 1

    heroku pg:backups:capture --app "$heroku_app" && \
    heroku pg:backups:download --app "$heroku_app" && \
    pg_restore --verbose --clean --no-acl --no-owner -h localhost -d "$1" latest.dump
  }
fi
