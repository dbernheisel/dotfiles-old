#!/usr/bin/env bash

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
