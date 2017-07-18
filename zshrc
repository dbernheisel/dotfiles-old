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

# asdf version manager autocompletes
source $HOME/.asdf/completions/asdf.bash

# Customize to your needs...
setopt extended_glob
unsetopt nomatch

# iTerm2 integration
if [[ "$OSTYPE" == darwin* ]]; then
  test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

  iterm2_print_user_vars() {
    iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
  }
fi

# awscli from brew auto-completion
if type aws &> /dev/null; then
  source /usr/local/share/zsh/site-functions/_aws
fi

# fzf Autocompletions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# PostgreSQL
export POSTGRES_USER=$(whoami)

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# tmuxinator
source ~/.asdf/installs/ruby/2.4.1/lib/ruby/gems/2.4.0/gems/tmuxinator-0.9.0/completion/tmuxinator.zsh

# RipGrep
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/**/*" --glob "!_build/**/*" --glob "!node_modules/**/*" --glob "!bower_components/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!.Trash/**/*"'

