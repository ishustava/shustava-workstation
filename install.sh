#!/bin/bash -eu

echo "Symlinking files"
ln -sf $PWD/.bash_profile $HOME/.zprofile
ln -sf $PWD/.bash_profile $HOME/.bash_profile
ln -sf $PWD/.gitconfig $HOME/.gitconfig
ln -sf $PWD/.git-prompt.sh $HOME/.git-prompt.sh
echo "Done symlinking files"

echo "Installing Homebrew"
if which brew > /dev/null
then
  echo "Homebrew already installed. Skipping installation."
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Running 'brew bundle'"
brew bundle

echo "Setting up vim"
curl vimfiles.luan.sh/install | bash
