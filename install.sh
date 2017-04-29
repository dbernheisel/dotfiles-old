#!/bin/bash

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Installing xcode"
xcode-select --install

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
  curl -fsS \
    'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

  append_to_zshrc '# recommended by brew doctor'
  append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1
  export PATH="/usr/local/bin:$PATH"
fi

brew install zsh

update_shell() {
  local shell_path;
  shell_path="$(brew --prefix zsh)/bin/zsh"

  if ! grep "^$shell_path" /etc/shells > /dev/null 2>&1 ; then
    fancy_echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  fancy_echo "Changing your shell to zsh ..."
  chsh -s "$shell_path"
}

case "$SHELL" in
  */zsh)
    if [ *"/bin/zsh"* == "$(brew --prefix zsh)/bin/zsh" ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
    asdf rehash
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

install_asdf() {
  fancy_echo "Installing asdf ..."
  if [ ! -d ~/.asdf ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    if [[ "$SHELL" == *zsh ]]; then
      append_to_zshrc "$HOME/.asdf/asdf.sh"
    fi
  else
    fancy_echo "asdf already installed"
  fi
  source "$HOME/.asdf/asdf.sh"
  return 0
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

install_asdf_plugins

install_zprezto() {
  fancy_echo "Installing zprezto ..."
  if [ ! -d ~/.zprezto ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md\(.N\); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  else
    fancy_echo "zprezto already installed"
  fi
}

install_zprezto

fancy_echo "Copying bernheisel zprezto theme"
cp prompt_bernheisel_setup ~/.zprezto/modules/prompt/functions/prompt_bernheisel_setup

folder=$(pwd)

fancy_echo "Backing up existing dotfiles"
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
  fancy_echo "Creating ~/.secrets file"
  touch "$HOME"/.secrets
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

fancy_echo "Installing programs"
brew update
brew bundle

fancy_echo "Cleaning up old Homebrew formulae ..."
brew cleanup
brew cask cleanup
brew prune

fancy_echo "Symlinking nvimrc"
ln -s ~/dotfiles/nvimrc  ~/.config/nvim/init.vim

fancy_echo "Symlinking tmux.conf"
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

fancy_echo "Symlinking ranger configs"
ln -s ~/dotfiles/ranger/rc.conf ~/.config/ranger/rc.conf
ln -s ~/dotfiles/ranger/scope.sh ~/.config/ranger/scope.sh

asdf_install_latest_version() {
  local latest_version
  latest_version=$(asdf list-all "$1" | tail -n 1)
  fancy_echo "Installing $1 $latest_version"
  asdf install "$1" "$latest_version"
  fancy_echo "Setting global version of $1 to $latest_version"
  asdf global "$1" "$latest_version"
}

asdf_install_latest_version ruby

fancy_echo "Installing tmuxinator"
gem_install_or_update tmuxinator

asdf_install_latest_version elixir
asdf_install_latest_version erlang
asdf_install_latest_version nodejs
asdf_install_latest_version golang
asdf_install_latest_version elm

asdf_install_latest_python_three() {
  local latest_version
  latest_version=$(asdf list-all python | grep -E '^3.*[^-dev]$' | tail -n 1)
  fancy_echo "Installing python $latest_version"
  asdf install python3 "$latest_version"
  fancy_echo "Setting global version of python3 to $latest_version"
  asdf global python3 "$latest_version"
}

asdf_install_latest_python_two() {
  local latest_version
  latest_version=$(asdf list-all python | grep -E '^2.*[^-dev]$' | tail -n 1)
  fancy_echo "Installing python $latest_version"
  asdf install python2 "$latest_version"
  fancy_echo "Setting global version of python2 to $latest_version"
  asdf global python2 "$latest_version"
}

asdf_install_latest_python_three
asdf_install_latest_python_two

fancy_echo "Installing google-cli https://www.npmjs.com/package/google-cli"
npm install -g google-cli

fancy_echo "Installing tldr https://www.npmjs.com/package/tldr"
npm install -g tldr

fancy_echo "Updating Apple macOS defaults"
if [[ "$OSTYPE" == darwin* ]]; then
  fancy_echo "Installing fonts"
  cp -vf ~/dotfiles/fonts/* ~/Library/Fonts

  fancy_echo "Enabling full keyboard access for all controls. e.g. enable Tab in modal dialogs"
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  fancy_echo "Setting a blazingly fast keyboard repeat rate (ain't nobody got time fo special chars while coding!)"
  defaults write NSGlobalDomain KeyRepeat -int 10

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
