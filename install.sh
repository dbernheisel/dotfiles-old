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

if ! command -v brew >/dev/null; then
  column
  fancy_echo "Installing Homebrew ..." "$yellow"
  curl -fsS \
    'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

  append_to_zshrc '# recommended by brew doctor'
  append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1
  export PATH="/usr/local/bin:$PATH"
fi

install_mas() {
  if ! command -v mas > /dev/null; then
    column
    fancy_echo "Installing MAS to manage Mac Apple Store installs" "$yellow"
    brew install mas
  fi
}

install_mas


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
	'bash_profile'
	'bashrc'
	'gitconfig'
	'gitignore'
  'gitmessage'
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
	ln -s "$folder/$f" "$HOME/.$f"
done

if [ ! -e "$HOME/.secrets" ]; then
  fancy_echo "Creating ~/.secrets file" "$yellow"
  touch "$HOME"/.secrets
fi

column
fancy_echo "Symlinking config files" "$yellow"
ln -s ~/dotfiles/nvimrc  ~/.config/nvim/init.vim
ln -s ~/dotfiles/aliases.sh ~/.aliases.sh
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/ranger/rc.conf ~/.config/ranger/rc.conf
ln -s ~/dotfiles/ranger/scope.sh ~/.config/ranger/scope.sh



#### Brew installs
column
fancy_echo "Installing programs" "$yellow"
if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
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

install_asdf

install_asdf_plugins() {
  local plugins=(
    'https://github.com/asdf-vm/asdf-erlang'
    'https://github.com/vic/asdf-elm'
    'https://github.com/asdf-vm/asdf-elixir'
    'https://github.com/asdf-vm/asdf-ruby'
    'https://github.com/kennyp/asdf-golang'
    'https://github.com/asdf-vm/asdf-nodejs'
  )

  for plugin in "${plugins[@]}"; do
    local language=${plugin##*-}
    asdf plugin-add $language $plugin
  done

  asdf plugin-add python3 https://github.com/tuvistavie/asdf-python
  asdf plugin-add python2 https://github.com/tuvistavie/asdf-python
}

fancy_echo "Installing asdf plugins ..." "$yellow"
install_asdf_plugins

asdf_install_latest_version() {
  local latest_version
  latest_version=$(asdf list-all "$1" | tail -n 1)
  fancy_echo "Installing $1 $latest_version" "$yellow"
  asdf install "$1" "$latest_version"
  fancy_echo "Setting global version of $1 to $latest_version"
  asdf global "$1" "$latest_version"
}

column

asdf_install_latest_version ruby
asdf_install_latest_version elixir
asdf_install_latest_version erlang
asdf_install_latest_version nodejs
asdf_install_latest_version elm

asdf_install_latest_python_three() {
  local latest_version
  latest_version=$(asdf list-all python | grep -E '^3.*[^-dev]$' | tail -n 1)
  fancy_echo "Installing python $latest_version" "$yellow"
  asdf install python3 "$latest_version"
  fancy_echo "Setting global version of python3 to $latest_version"
  asdf global python3 "$latest_version"
}

asdf_install_latest_python_two() {
  local latest_version
  latest_version=$(asdf list-all python | grep -E '^2.*[^-dev]$' | tail -n 1)
  fancy_echo "Installing python $latest_version" "$yellow"
  asdf install python2 "$latest_version"
  fancy_echo "Setting global version of python2 to $latest_version"
  asdf global python2 "$latest_version"
}

asdf_install_latest_golang() {
  local latest_version
  latest_version=$(asdf list-all golang | grep -E 'darwin' | grep -v 'rc' | grep -v 'beta' | grep -E 'amd64' | tail -n 1)
  fancy_echo "Installing golang $latest_version" "$yellow"
  asdf install golang "$latest_version"
  fancy_echo "Setting global verison of golang to $latest_version"
  asdf global golang "$latest_version"
}

asdf_install_latest_python_three
asdf_install_latest_python_two
asdf_install_latest_golang


#### Tools
column
fancy_echo "Installing tmuxinator https://github.com/tmuxinator/tmuxinator"
gem_install_or_update tmuxinator
fancy_echo "Installing google-cli https://www.npmjs.com/package/google-cli"
npm_install_or_update google-cli
fancy_echo "Installing tldr https://www.npmjs.com/package/tldr"
npm_install_or_update tldr



#### Apple macOS defaults
column
fancy_echo "Updating Apple macOS defaults" "$yellow"
if [[ "$OSTYPE" == darwin* ]]; then
  fancy_echo "Installing fonts"
  cp -vf ~/dotfiles/fonts/* ~/Library/Fonts

  fancy_echo "Enabling full keyboard access for all controls. e.g. enable Tab in modal dialogs"
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  fancy_echo "Setting a blazingly fast keyboard repeat rate"
  defaults write NSGlobalDomain KeyRepeat -int 1

  fancy_echo "Disable smart quotes and smart dashes as they're annoying when typing code"
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  fancy_echo "Automatically quit printer app once the print jobs complete"
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  fancy_echo "Enabling Safari debug menu"
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  fancy_echo "Enabling the Develop menu and the Web Inspector in Safari"
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

  fancy_echo "Adding a context menu item for showing the Web Inspector in web views"
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
fi
