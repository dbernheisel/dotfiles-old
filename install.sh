#!/usr/bin/env bash

# Install prezto first.
# https://github.com/sorin-ionescu/prezto

: '
########################
# INSTALL INSTRUCTIONS #
########################

zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
chsh -s /bin/zsh
bash install.sh

'

folder=$(pwd)

echo "Backing up existing dotfiles"
files=(
	'bash_profile'
	'bashrc'
	'gitconfig'
	'gitignore'
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
	if [ ! -e "$HOME/.secrets" ]; then
		touch "$HOME"/.secrets
	fi
	ln -s "$folder/$f" "$HOME/.$f"
done

echo ""
echo "Copying zprezto theme"
cp prompt_bernheisel_setup ~/.zprezto/modules/prompt/functions/prompt_bernheisel_setup

echo ""
echo "Installing google-cli https://www.npmjs.com/package/google-cli"
npm install -g google-cli

echo ""
echo "Installing tldr https://www.npmjs.com/package/tldr"
npm install -g tldr

echo ""
echo "Symlinking nvimrc"
ln -s ~/dotfiles/nvimrc  ~/.config/nvim/init.vim

echo ""
echo "Symlinking tmux.conf"
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf

echo ""
echo "Symlinking ranger configs"
ln -s ~/dotfiles/ranger/rc.conf ~/.config/ranger/rc.conf
ln -s ~/dotfiles/ranger/scope.sh ~/.config/ranger/scope.sh

echo ""
echo "Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo ""
echo "Setting a blazingly fast keyboard repeat rate (ain't nobody got time fo special chars while coding!)"
defaults write NSGlobalDomain KeyRepeat -int 0

echo ""
echo "Disable smart quotes and smart dashes as theyâ€™re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo ""
echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo ""
echo "Enabling Safari debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo ""
echo "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
echo "Adding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
