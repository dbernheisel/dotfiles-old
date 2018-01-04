#!/bin/bash


#### Helper funcions
column() {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

mkcolor() {
  # shellcheck disable=SC1117
  [ "${BASH_VERSINFO[0]}" -le "3" ] && echo -e "\033[00;$1m" || echo "\e[0;$1m"
}

mkbold() {
  # shellcheck disable=SC1117
  [ "${BASH_VERSINFO[0]}" -le "3" ] && echo -e "\033[1;$1m" || echo "\e[1;$1m"
}

clear=$(mkcolor 0)
yellow=$(mkbold 33)
red=$(mkbold 31)

fancy_echo() {
  local fmt="$1"; shift
  local color="$1"; shift

  # shellcheck disable=SC2059
  # shellcheck disable=SC1117
  printf "$color$fmt$clear\n" "$@"
}

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
    asdf rehash
  fi
}

npm_install_or_update() {
  local program
  program=$1; shift

  if npm -g list --depth=1 2> /dev/null | grep "$program" > /dev/null; then
    npm -g update "$program"
  else
    npm -g install "$program"
  fi
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      # shellcheck disable=SC1117
      printf "%s\n" "$text" >> "$zshrc"
    else
      # shellcheck disable=SC1117
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

is_mac() {
  if [[ "$OSTYPE" == darwin* ]]; then
    return 0
  else
    return 1
  fi
}

is_ubuntu() {
  if [[ "$OSTYPE" == linux* ]] && uname -a | grep -q Ubuntu; then
    return 0
  else
    return 1
  fi
}


#### Prerequisites, like xcode and homebrew
if is_mac; then
  column
  fancy_echo "Installing xcode command line tools" "$yellow"
  xcode-select --install
fi

if is_ubuntu; then
  column
  fancy_echo "Installing build-essential command line tools" "$yellow"
  common_reqs=(build-essential curl)
  python_reqs=(make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev)
  ruby_reqs=(gcc-6 autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev)
  erlang_reqs=(build-essential libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng3 libssh-dev unixodbc-dev m4 libncurses5-dev autoconf)
  # shellcheck disable=SC2128
  # shellcheck disable=SC2207
  combined=($(for req in "${common_reqs}" "${python_reqs[@]}" "${ruby_reqs[@]}" "${erlang_reqs[@]}"; do echo "$req" ; done | sort -du))
  # shellcheck disable=SC2128
  # shellcheck disable=SC2086
  sudo apt-get install $combined
fi

if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
  column
  fancy_echo "You need to generate an SSH key first" "$red"
  ssh-keygen
fi

if is_mac && ! command -v brew >/dev/null; then
  column
  fancy_echo "Installing Homebrew ..." "$yellow"
  curl -fsS \
    'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

  append_to_zshrc '# recommended by brew doctor'
  # shellcheck disable=SC2016
  append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1
  export PATH="/usr/local/bin:$PATH"
fi

if is_mac && ! command -v mas > /dev/null; then
  column
  fancy_echo "Installing MAS to manage Mac Apple Store installs" "$yellow"
  brew install mas
fi



#### Install zsh
update_shell() {
  local shell_path;
  shell_path="$(brew --prefix zsh)/bin/zsh"
  if [ "$SHELL" != "$shell_path" ]; then

    column
    fancy_echo "Changing your shell to zsh ..." "$yellow"
    if ! grep "^$shell_path" /etc/shells > /dev/null 2>&1 ; then
      brew install zsh
      sudo sh -c "echo $shell_path >> /etc/shells"
    fi
    chsh -s "$shell_path"
  fi
}

if is_mac; then
  case "$SHELL" in
    */zsh)
      if [[ "$(brew --prefix zsh)/bin/zsh" == */bin/zsh* ]] ; then
        update_shell
      fi
      ;;
    *)
      update_shell
      ;;
  esac
fi


#### Install dotfiles
install_zprezto() {
  if [ ! -d "$HOME/.zprezto" ]; then
    column
    fancy_echo "Installing zprezto ..." "$yellow"
    git clone --recursive git://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md\(.N\); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  fi
}

install_zprezto
cp prompt_bernheisel_setup "$HOME/.zprezto/modules/prompt/functions/prompt_bernheisel_setup"

column
fancy_echo "Backing up existing dotfiles" "$yellow"
folder=$(pwd)
files=(
  'aliases.sh'
  'bash_profile'
  'bashrc'
  'gitconfig'
  'gitignore'
  'gitmessage'
  'tmux.conf'
  'irbrc'
  'pryrc'
  'zlogin'
  'zlogout'
  'zpreztorc'
  'zprofile'
  'zshenv'
  'zshrc'
)

mkdir -p "$folder/backup" 2>/dev/null
for f in "${files[@]}"; do
  if [ -e "$HOME/.$f" ]; then
    mv -v "$HOME/.$f" "$folder/backup/.$f"
  fi
  ln -fs "$folder/$f" "$HOME/.$f"
done

if [ ! -e "$HOME/.secrets" ]; then
  fancy_echo "Creating secrets file" "$yellow"
  touch "$HOME/.secrets"
fi

column
fancy_echo "Symlinking config files" "$yellow"
ln -fs "$HOME/dotfiles/aliases.sh" "$HOME/.aliases.sh"
ln -fs "$HOME/dotfiles/tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/nvim"
mv -v "$HOME/.config/nvim/init.vim" "$folder/backup/init.vim"
ln -fs "$HOME/dotfiles/nvimrc" "$HOME/.config/nvim/init.vim"

mkdir -p "$HOME/.config/ranger"
mkdir -p "$folder/backup/ranger"
mv -v "$HOME/.config/ranger/rc.conf" "$folder/backup/ranger/rc.conf"
mv -v "$HOME/.config/ranger/scope.sh" "$folder/backup/rangers/scope.sh"
ln -fs "$HOME/dotfiles/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
ln -fs "$HOME/dotfiles/ranger/scope.sh" "$HOME/.config/ranger/scope.sh"

mkdir -p "$HOME/Library/Preferences/kitty"
mv -v "$HOME/Library/Preferences/kitty/kitty.conf" "$folder/backup/kitty.conf"
ln -fs "$HOME/dotfiles/kitty.conf" "$HOME/Library/Preferences/kitty/kitty.conf"


#### Brew installs
if is_mac; then
  column
  fancy_echo "Installing programs" "$yellow"
  if brew list | grep -Fq brew-cask; then
    fancy_echo "Uninstalling old Homebrew-Cask ..." "$yellow"
    brew uninstall --force brew-cask
  fi
  brew update
  brew bundle
  brew cleanup
  brew cask cleanup
  brew prune
fi


#### asdf Install, plugins, and languages
column
install_asdf() {
  if [ ! -d "$HOME/.asdf" ]; then
    fancy_echo "Installing asdf ..." "$yellow"
    git clone git://github.com/asdf-vm/asdf.git "$HOME/.asdf"
    if [[ "$SHELL" == *zsh ]]; then
      append_to_zshrc "$HOME/.asdf/asdf.sh"
    fi
  fi

  # shellcheck disable=SC1090
  source "$HOME/.asdf/asdf.sh"
}

install_asdf_plugin() {
  local language="$1"; shift
  if asdf plugin-list | grep -v "$language" >/dev/null; then
    asdf plugin-add "$language"
  fi
}

asdf_install_latest_version() {
  if command -v asdf >/dev/null; then
    local language="$1"; shift
    local latest_version
    install_asdf_plugin "$language"
    latest_version=$(asdf list-all "$language" | grep -v '[A-Za-z-]' | tail -n 1)
    fancy_echo "Installing $language $latest_version" "$yellow"
    asdf install "$language" "$latest_version"
    fancy_echo "Setting global version of $language to $latest_version" "$yellow"
    asdf global "$language" "$latest_version"
  else
    fancy_echo "Could not install language for asdf. Could not find asdf" "$red" && false
  fi
}

asdf_install_latest_nodejs() {
  local language="nodejs"
  local latest_version
  install_asdf_plugin "$language"
  export GNUPGHOME="${ASDF_DIR:-$HOME/.asdf}/keyrings/nodejs" && mkdir -p "$GNUPGHOME" && chmod 0700 "$GNUPGHOME"
  # shellcheck disable=SC1090
  source "$HOME/.asdf/plugins/$language/bin/import-release-team-keyring"
  latest_version=$(asdf list-all "$language" | grep -v '[A-Za-z-]' | tail -n 1)
  fancy_echo "Installing $language $latest_version" "$yellow"
  asdf install "$language" "$latest_version"
  fancy_echo "Setting global version of $language to $latest_version" "$yellow"
  asdf global "$language" "$latest_version"
  unset GNUPGHOME
}

asdf_install_latest_pythons() {
  local latest_2_version
  local latest_3_version
  local language="python"
  install_asdf_plugin "$language"
  latest_2_version=$(asdf list-all $language | grep -v '^2.*' | grep -v '[A-Za-z-]' | tail -n 1)
  latest_3_version=$(asdf list-all $language | grep -v '^3.*' | grep -v '[A-Za-z-]' | tail -n 1)
  fancy_echo "Installing python $latest_2_version" "$yellow"
  asdf install "$language" "$latest_2_version" && brew unlink python2
  fancy_echo "Installing python $latest_3_version" "$yellow"
  asdf install "$language" "$latest_3_version" && brew unlink python3
  fancy_echo "Setting global version of $language to $latest_3_version $latest_2_version" "$yellow"
  asdf global "$language" "$latest_3_version" "$latest_2_version"
}

asdf_install_latest_golang() {
  local language="golang"
  local goarch
  local goarchbit
  case "$OSTYPE" in
    darwin*)  goarch="darwin" ;;
    linux*)   goarch="linux" ;;
    bsd*)     goarch="freebsd" ;;
    *)        fancy_echo "Cannot determine system for golang" "$red" && exit 1;;
  esac
  case $(uname -m) in
    i?86)   goarchbit=386 ;;
    x86_64) goarchbit=amd64 ;;
    ppc64)  goarchbit=ppc64 ;;
    *)      fancy_echo "Cannot determine system for golang" "$red" && exit 1;;
  esac

  install_asdf_plugin $language
  local latest_version
  latest_version=$(asdf list-all golang | grep -E $goarch | grep -v 'rc' | grep -v 'src' | grep -v 'beta' | grep -E $goarchbit | tail -n 1)
  fancy_echo "Installing $language $latest_version" "$yellow"
  asdf install "$language" "$latest_version"
  fancy_echo "Setting global verison of $language to $latest_version" "$yellow"
  asdf global "$language" "$latest_version"
}

install_asdf &&\
  asdf_install_latest_version ruby &&\
  asdf_install_latest_version erlang &&\
  asdf_install_latest_version elixir &&\
  asdf_install_latest_version elm &&\
  asdf_install_latest_nodejs &&\
  asdf_install_latest_pythons &&\
  asdf_install_latest_golang


#### Tools
column
fancy_echo "Installing neovim plugins for languages"
gem_install_or_update neovim
pip2 install neovim
pip3 install neovim

fancy_echo "Installing eslint" "$yellow"
npm_install_or_update eslint
npm_install_or_update babel-eslint

fancy_echo "Installing alias-tips for zsh"
git clone git://github.com/djui/alias-tips.git "$HOME/.zprezto/modules/alias-tips"


#### Apple macOS defaults
if is_mac; then
  column
  fancy_echo "Updating Apple macOS defaults" "$yellow"

  fancy_echo "Enabling full keyboard access for all controls. e.g. enable Tab in modal dialogs" "$yellow"
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  fancy_echo "Setting a blazingly fast keyboard repeat rate" "$yellow"
  defaults write NSGlobalDomain KeyRepeat -int 1

  fancy_echo "Disable smart quotes and smart dashes as they're annoying when typing code" "$yellow"
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  fancy_echo "Automatically quit printer app once the print jobs complete" "$yellow"
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  fancy_echo "Enabling Safari debug menu" "$yellow"
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  fancy_echo "Enabling the Develop menu and the Web Inspector in Safari" "$yellow"
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

  fancy_echo "Adding a context menu item for showing the Web Inspector in web views" "$yellow"
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
fi
