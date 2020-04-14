#!/bin/bash
#
# Installs all needed software, ruby gems, Homebrew packages and casks
#
set -uo pipefail

command -v brew >/dev/null 2>&1 || { 
  echo "#################################################################"
  echo "Installing Homebrew"
  echo "#################################################################"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

echo "#################################################################"
echo "Installing Software via Homebrew"
echo "#################################################################"

# Install/Upgrade software via Brewfile
brew update
brew bundle -v --global
brew cleanup
brew doctor

echo "#################################################################"
echo "Installing Powerline Fonts For iTerm"
echo "#################################################################"

tmp="$(mktemp -d)/fonts"
git clone https://github.com/powerline/fonts.git --depth=1 $tmp
$tmp/install.sh
rm -rf $tmp

echo "#################################################################"
echo "Setting up ZSH with Oh-My-Zsh"
echo "Credits: https://stackoverflow.com/a/17649823/971329"
echo "#################################################################"

grep -q /usr/local/bin/zsh /etc/shells || {
  # append zsh to the end of /etc/shells
  sudo sh -c "echo /usr/local/bin/zsh >> /etc/shells"
  # change default shell
  chsh -s /usr/local/bin/zsh
  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}