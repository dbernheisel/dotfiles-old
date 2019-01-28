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

# Customize to your needs...
setopt extended_glob
unsetopt nomatch

# awscli from brew auto-completion
if type aws &> /dev/null; then
  source /usr/local/share/zsh/site-functions/_aws
fi

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

# Linuxbrew
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# fzf Autocompletions
if type fzf &> /dev/null; then
  if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
  else
    echo "Running fzf install"
    $(brew --prefix)/opt/fzf/install
  fi
fi

# asdf version manager
[ -f $HOME/.asdf/asdf.sh ] && source $HOME/.asdf/asdf.sh
[ -f $HOME/.asdf/asdf.sh ] && source $HOME/.asdf/completions/asdf.bash

# Newer git
[ -f $(brew --prefix git)/bin/git ] && export PATH=$(brew --prefix git)/bin:$PATH

# Rust
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# RipGrep
export FZF_DEFAULT_OPTS='--color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229 --color info:150,prompt:110,spinner:150,pointer:167,marker:174'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/**/*" --glob "!_build/**/*" --glob "!.elixir_ls/**/*" --glob "!node_modules/**/*" --glob "!bower_components/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!.Trash/**/*"'

source ~/.aliases.sh
source ~/.secrets

export PATH=~/dotfiles/bin:$PATH

[ -e "$HOME/.zshlocal" ] && source "$HOME/.zshlocal"
