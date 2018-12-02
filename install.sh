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
  fi
}

pip_install_or_update() {
  pip3 install "$1" -U
}

yarn_install_or_update() {
  yarn global add "$1" --latest
}

append_to_file() {
  local filename="$1"; shift
  local text="$1"; shift
  local skip_new_line="${1:-0}"
  local file

  if [ -w "$HOME/.$filename.local" ]; then
    file="$HOME/.$filename.local"
  else
    file="$HOME/.$filename"
  fi

  if ! grep -Fqs "$text" "$file"; then
    if [ "$skip_new_line" -eq 1 ]; then
      # shellcheck disable=SC1117
      printf "%s\n" "$text" >> "$file"
    else
      # shellcheck disable=SC1117
      printf "\n%s\n" "$text" >> "$file"
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

is_linux() {
  if [[ "$OSTYPE" == linux* ]]; then
    return 0
  else
    return 1
  fi
}

is_debian() {
  if [ -f /etc/debian_version ]; then
    return 0
  else
    return 1
  fi
}

is_fedora() {
  if is_linux && uname -a | grep -q Fedora; then
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

if is_linux; then
  column
  fancy_echo "Installing essential source-building packages" "$yellow"
  fancy_echo "This may ask for sudo access for installs..." "$yellow"

  if is_debian && ! grep "^[^#;]" Aptfile | sort -u | xargs sudo apt-get install -y; then
    fancy_echo "Could not install system utilities. Please install those and then re-run this script" "$red"
    exit 1
  fi

  if is_fedora && ! grep "^[^#;]" Dnffile | sort -u | xargs sudo dnf install -y; then
    fancy_echo "Could not install system utilities. Please install those and then re-run this script" "$red"
    exit 1
  fi
fi

if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
  column
  fancy_echo "You need to generate an SSH key" "$red"
  ssh-keygen
fi

if is_mac && ! command -v brew >/dev/null; then
  column
  fancy_echo "Installing Homebrew ..." "$yellow"
  curl -fsS \
    'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

  append_to_file zshrc '# recommended by brew doctor'
  append_to_file bashrc '# recommended by brew doctor'
  # shellcheck disable=SC2016
  append_to_file zshrc 'export PATH="/usr/local/bin:$PATH"' 1
  # shellcheck disable=SC2016
  append_to_file bashrc 'export PATH="/usr/local/bin:$PATH"' 1
  export PATH="/usr/local/bin:$PATH"

  if ! command -v mas > /dev/null; then
    column
    fancy_echo "Installing MAS to manage Mac Apple Store installs" "$yellow"
    brew install mas
  fi
fi

if is_linux && ! command -v brew >/dev/null; then
  column
  fancy_echo "Installing Linuxbrew ..." "$yellow"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r ~/.bashrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
  test -r ~/.zshrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.zshrc
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


#### Brew installs
column
fancy_echo "Installing programs" "$yellow"
if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..." "$yellow"
  brew uninstall --force brew-cask
fi
brew update
brew bundle check || brew bundle
brew cleanup
brew prune


#### Setup dotfiles
column
fancy_echo "Backing up existing dotfiles" "$yellow"
folder=$(pwd)
files=(
  aliases.sh
  bash_profile
  bashrc
  ctags
  gemrc
  default-gems
  default-npm-packages
  gitconfig
  gitignore
  gitmessage
  irbrc
  pryrc
  psqlrc
  tmux.conf
  zlogin
  zlogout
  zpreztorc
  zprofile
  zshenv
  zshrc
)

mkdir -p "$folder/backup" 2>/dev/null
for f in "${files[@]}"; do
  if [ -e "$HOME/.$f" ]; then
    mv -v "$HOME/.$f" "$folder/backup/.$f"
  fi
done

column
fancy_echo "Symlinking config files" "$yellow"
for f in "${files[@]}"; do
  ln -fs "$folder/$f" "$HOME/.$f"
done

if [ ! -e "$HOME/.secrets" ]; then
  fancy_echo "Creating secrets file" "$yellow"
  touch "$HOME/.secrets"
fi

if [ ! -e "$HOME/.zshlocal" ]; then
  fancy_echo "Creating local zsh config" "$yellow"
  touch "$HOME/.zshlocal"
fi

#### asdf Install, plugins, and languages
column
install_asdf() {
  if [ ! -d "$HOME/.asdf" ]; then
    fancy_echo "Installing asdf ..." "$yellow"
    git clone git://github.com/asdf-vm/asdf.git "$HOME/.asdf"
    if [[ "$SHELL" == *zsh ]]; then
      append_to_file zshrc "$HOME/.asdf/asdf.sh"
    fi
  fi

  # shellcheck disable=SC1090
  source "$HOME/.asdf/asdf.sh"
}

install_asdf_plugin() {
  local language="$1"; shift
  if ! asdf plugin-list | grep -v "$language" >/dev/null; then
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
  if is_mac; then
    CFLAGS="-O2 -I$(xcrun --show-sdk-path)/usr/include" \
      asdf install "$language" "$latest_2_version" && \
      brew unlink python2
  else
    asdf install "$language" "$latest_2_version"
  fi

  fancy_echo "Installing python $latest_3_version" "$yellow"
  if is_mac; then
    CFLAGS="-O2 -I$(xcrun --show-sdk-path)/usr/include" \
      asdf install "$language" "$latest_3_version" && \
      brew unlink python3
  else
    asdf install "$language" "$latest_3_version"
  fi

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

install_asdf
if type asdf &> /dev/null; then
  asdf_install_latest_version ruby
  asdf_install_latest_nodejs
  asdf_install_latest_pythons

  #### Tools
  column
  fancy_echo "Installing neovim plugins for languages" "$yellow"
  gem_install_or_update neovim
  pip2 install neovim
  pip3 install neovim
  pip3 install neovim-remote
  pip3 install pyls
fi

VIM_FILES=(
  plugs.vim
  language-servers.vim
  terminal.vim
)
mkdir -p "$HOME/.config/nvim"
mv -v "$HOME/.config/nvim" "$folder/backup/nvim"
mkdir -p "$HOME/.config/nvim"
ln -fs "$HOME/dotfiles/nvimrc" "$HOME/.config/nvim/init.vim"
ln -fs "$HOME/dotfiles/vim/after" "$HOME/.config/nvim/after"
for f in "${VIM_FILES[@]}"; do
  ln -fs "$HOME/dotfiles/vim/$f" "$HOME/.config/nvim/$f"
done

fancy_echo "Installing language servers" "$yellow"
yarn_install_or_update vscode-json-languageserver-bin
yarn_install_or_update vscode-html-languageserver-bin
yarn_install_or_update vscode-css-languageserver-bin
yarn_install_or_update ocaml-language-server
yarn_install_or_update javascript-typescript-language-server
(
  git clone git@github.com:JakeBecker/elixir-ls.git ~/.elixir_ls
  cd ~/.elixir_ls || exit 1
  mix deps.get && mix.compile
  mix elixir_ls.release - .
)
(
  git clone git@github.com:fwcd/KotlinLanguageServer.git ~/.kotlin_ls
  cd ~/.kotlin_ls || exit 1
  ./gradlew installDist
)

fancy_echo "Installing alias-tips for zsh" "$yellow"
git clone git://github.com/djui/alias-tips.git "$HOME/.zprezto/modules/alias-tips"

fancy_echo "Registering tmux terminfo for italics" "$yellow"
tic $HOME/dotfiles/tmux-italics.terminfo

mkdir -p "$HOME/.config/ranger"
mkdir -p "$folder/backup/ranger"
mv -v "$HOME/.config/ranger/rc.conf" "$folder/backup/ranger/rc.conf"
mv -v "$HOME/.config/ranger/scope.sh" "$folder/backup/rangers/scope.sh"
ln -fs "$HOME/dotfiles/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
ln -fs "$HOME/dotfiles/ranger/scope.sh" "$HOME/.config/ranger/scope.sh"

is_mac && kitty_home="$HOME/Library/Preferences/kitty"
is_linux && kitty_home="$HOME/.config/kitty"
mkdir -p "$kitty_home"
mv -v "$kitty_home/kitty.conf" "$folder/backup/kitty.conf"
ln -fs "$HOME/dotfiles/kitty.conf" "$kitty_home/kitty.conf"
unset kitty_home

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

  fancy_echo "Turning on AptX and AAC codecs over Bluetooth for non-Apple devices" "$yellow"
  defaults write bluetoothaudiohd "Enable AptX codec" -bool true
  defaults write bluetoothaudiohd "Enable AAC codec" -bool true
fi
