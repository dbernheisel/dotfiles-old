#
# Executes commands at login pre-zshrc.
#

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)

# Less
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

# asdf version manager
# Autocompletions are sourced in zshrc
[ -f $HOME/.asdf/asdf.sh ] && source $HOME/.asdf/asdf.sh

source ~/.secrets
# Newer git
[ -f /usr/local/opt/git ] && export PATH=/usr/local/opt/git:$PATH

# Oracle
# If using ruby-oci8, you'll need gem version >=2.2.1
[ -f ~/.oracle-client.sh ] && source ~/.oracle-client.sh

# Postgres
export POSTGRES_USER="davidbernheisel"

# Neovim
if type "nvim" &> /dev/null; then
  function vim() {
    nvim $argv
  }
fi
# This is how to configure iTerm2 to send the correct CSI for ctrl+h:
#
# Edit -> Preferences -> Keys
# Press +
# Press Ctrl+h as Keyboard Shortcut
# Choose Send Escape Sequence as Action
# Type [104;5u


# Use Exhuburant ctags
if [ -f "$(brew --prefix)/bin/ctags)" ]; then
 alias ctags="$(brew --prefix)/bin/ctags"
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


# Android development
alias adb='/Users/davidbernheisel/Library/Android/sdk/platform-tools/adb'
export ANDROID_HOME=/usr/local/opt/android-sdk
export JAVA_HOME=/Library/Java/Home


# Alias some docker commands
alias docker_rm_images="docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs docker rmi"
alias docker_rm_containers="docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v"
alias docker_rm_volumes="docker volume ls -qf dangling=true | xargs docker volume rm"
alias docker_clean="docker_rm_images && docker_rm_containers && docker_rm_volumes"

# Alias some NPM tools
alias google='googler -n 10'

# Alias some Ruby/Bundler/Rails commands
alias be='bundle exec'
alias sandbox='rails c --sandbox'

# Alias SourceTree to open in current dir
alias sourcetree='open -a SourceTree ./'

# rbenv. Rbenv is sourced in zshrc
alias rbenv-update='(cd ~/.rbenv/plugins/ruby-build && git pull)'

