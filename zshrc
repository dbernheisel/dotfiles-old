#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source $HOME/.aliases.sh

# asdf version manager autocompletes
source $HOME/.asdf/completions/asdf.bash

# Customize to your needs...
setopt extended_glob
unsetopt nomatch

# awscli from brew auto-completion
if type aws &> /dev/null; then
  source /usr/local/share/zsh/site-functions/_aws
fi

# fzf Autocompletions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Android Development
export PATH=~/flutter/bin:$PATH
export ANDROID_HOME=~/Library/Android/sdk

# PostgreSQL
export POSTGRES_USER=$(whoami)

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"
if [ -f ~/.elixir_ls/language_server.sh ]; then
  export PATH=~/.elixir_ls:$PATH
fi

# Kotlin
if [ -f ~/.kotlin_ls/build/install/kotlin-language-server/bin/kotlin-language-server ]; then
  export PATH=~/.kotlin_ls/build/install/kotlin-language-server/bin:$PATH
fi

# RipGrep
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/**/*" --glob "!_build/**/*" --glob "!.elixir_ls/**/*" --glob "!node_modules/**/*" --glob "!bower_components/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!.Trash/**/*"'

# recommended by brew doctor
export PATH="/usr/local/bin:$PATH"

source ~/.asdf/asdf.sh

[ -e "$HOME/.zshlocal" ] && source "$HOME/.zshlocal"
