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
echo "Symlinking nvimrc"
ln -s ~/dotfiles/.nvimrc  ~/.config/nvim/init.vim

echo ""
echo "Symlinking ranger configs"
ln -s ~/dotfiles/ranger/rc.conf ~/.config/ranger/rc.conf
ln -s ~/dotfiles/ranger/scope.sh ~/.config/ranger/scope.sh

