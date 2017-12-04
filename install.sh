#!/bin/bash


#### Helper funcions
column() {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

mkcolor() {
  [ "${BASH_VERSINFO[0]}" -le "3" ] && echo -e "\033[00;$1m" || echo "\e[0;$1m"
}

mkbold() {
  [ "${BASH_VERSINFO[0]}" -le "3" ] && echo -e "\033[1;$1m" || echo "\e[1;$1m"
}

clear=$(mkcolor 0)
yellow=$(mkbold 33)
red=$(mkbold 31)
green=$(mkbold 32)

fancy_echo() {
  local fmt="$1"; shift
  local color="$1"; shift

  # shellcheck disable=SC2059
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
  npm -g list --depth=1 2> /dev/null | grep "$program" > /dev/null
  if [ $? -eq 0 ]; then
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
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}



#### Prerequisites, like xcode and homebrew
column
fancy_echo "Installing xcode command line tools" "$yellow"
xcode-select --install

if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
  column
  fancy_echo "You need to generate an SSH key first" "$red"
  fancy_echo "Run `ssh-keygen`, and then run this install script again"
  cd ~/.ssh
  exit 1
fi

if ! command -v brew >/dev/null; then
  column
  fancy_echo "Installing Homebrew ..." "$yellow"
  curl -fsS \
    'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

  append_to_zshrc '# recommended by brew doctor'
  append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1
  export PATH="/usr/local/bin:$PATH"
fi

if ! command -v mas > /dev/null; then
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



#### Install dotfiles
install_zprezto() {
  if [ ! -d ~/.zprezto ]; then
    column
    fancy_echo "Installing zprezto ..." "$yellow"
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md\(.N\); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  fi
}

install_zprezto
cp prompt_bernheisel_setup ~/.zprezto/modules/prompt/functions/prompt_bernheisel_setup

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
  fancy_echo "Creating ~/.secrets file" "$yellow"
  touch "$HOME"/.secrets
fi

column
fancy_echo "Symlinking config files" "$yellow"
ln -fs ~/dotfiles/aliases.sh ~/.aliases.sh
ln -fs ~/dotfiles/tmux.conf ~/.tmux.conf

mkdir -p ~/.config/nvim
mv -v "$HOME/.config/nvim/init.vim" "$folder/backup/init.vim"
ln -fs ~/dotfiles/nvimrc  ~/.config/nvim/init.vim

mkdir -p "~/.config/ranger"
mkdir -p "$folder/backup/ranger"
mv -v "$HOME/.config/ranger/rc.conf" "$folder/backup/ranger/rc.conf"
mv -v "$HOME/.config/ranger/scope.sh" "$folder/backup/rangers/scope.sh"
ln -fs ~/dotfiles/ranger/rc.conf ~/.config/ranger/rc.conf
ln -fs ~/dotfiles/ranger/scope.sh ~/.config/ranger/scope.sh

mkdir -p ~/Library/Preferences/kitty
mv -v "~/Library/Preferences/kitty/kitty.conf" "$folder/backup/kitty.conf"
ln -fs ~/dotfiles/kitty.conf ~/Library/Preferences/kitty/kitty.conf


#### Brew installs
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


#### asdf Install, plugins, and languages
column
install_asdf() {
  if [ ! -d ~/.asdf ]; then
    fancy_echo "Installing asdf ..." "$yellow"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    if [[ "$SHELL" == *zsh ]]; then
      append_to_zshrc "$HOME/.asdf/asdf.sh"
    fi
  fi
  source "$HOME/.asdf/asdf.sh"
}

install_asdf_plugins() {
  export GNUPGHOME="${ASDF_DIR:-$HOME/.asdf}/keyrings/nodejs" && mkdir -p "$GNUPGHOME" && chmod 0700 "$GNUPGHOME"
  local plugins=(
    'https://github.com/asdf-vm/asdf-erlang'
    'https://github.com/vic/asdf-elm'
    'https://github.com/asdf-vm/asdf-elixir'
    'https://github.com/asdf-vm/asdf-ruby'
    'https://github.com/kennyp/asdf-golang'
    'https://github.com/asdf-vm/asdf-nodejs'
    'https://github.com/tuvistavie/asdf-python'
  )

  if command -v asdf >/dev/null; then
    for plugin in "${plugins[@]}"; do
      local language=${plugin##*-}
      asdf plugin-add "$language" "$plugin"
    done

    source "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring"
  else
    fancy_echo "Could not install plugins for asdf. Could not find asdf" "$red" && false
  fi
  unset GNUPGHOME
}

asdf_install_latest_version() {
  local language="$1"; shift
  local latest_version=$(asdf list-all "$language" | tail -n 1)
  fancy_echo "Installing $language $latest_version" "$yellow"
  asdf install "$language" "$latest_version"
  fancy_echo "Setting global version of $language to $latest_version" "$yellow"
  asdf global "$language" "$latest_version"
}

asdf_install_latest_pythons() {
  local latest_2_version
  local latest_3_version
  latest_2_version=$(asdf list-all python | grep -E '^2.*[^-dev]$' | tail -n 1)
  latest_3_version=$(asdf list-all python | grep -E '^3.*[^-dev]$' | tail -n 1)
  fancy_echo "Installing python $latest_2_version" "$yellow"
  asdf install python "$latest_2_version" && brew unlink python2
  fancy_echo "Installing python $latest_3_version" "$yellow"
  asdf install python "$latest_3_version" && brew unlink python3
  fancy_echo "Setting global version of python to $latest_3_version $latest_2_version" "$yellow"
  asdf global python "$latest_3_version" "$latest_2_version"
}

asdf_install_latest_golang() {
  if [[ "$OSTYPE" == darwin* ]]; then
    local latest_version
    latest_version=$(asdf list-all golang | grep -E 'darwin' | grep -v 'rc' | grep -v 'beta' | grep -E 'amd64' | tail -n 1)
    fancy_echo "Installing golang $latest_version" "$yellow"
    asdf install golang "$latest_version"
    fancy_echo "Setting global verison of golang to $latest_version" "$yellow"
    asdf global golang "$latest_version"
  fi
}

install_asdf &&\
  install_asdf_plugins &&\
  asdf_install_latest_version ruby &&\
  asdf_install_latest_version erlang &&\
  asdf_install_latest_version elixir &&\
  asdf_install_latest_version nodejs &&\
  asdf_install_latest_version elm &&\
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
git clone https://github.com/djui/alias-tips.git ~/.zprezto/modules/alias-tips


#### Apple macOS defaults
if [[ "$OSTYPE" == darwin* ]]; then
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
