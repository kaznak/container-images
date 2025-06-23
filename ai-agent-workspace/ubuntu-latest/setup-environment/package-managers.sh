#!/bin/bash

set -euo pipefail

# Homebrew on Linux installation
if [ ! -d "$HOME/.linuxbrew" ]; then
    git clone https://github.com/Homebrew/brew $HOME/.linuxbrew
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/$BASH_ENV
    brew update --force --quiet
    chmod -R go-w "$(brew --prefix)/share/zsh"
else
    echo "Homebrew is already installed. Skipping Homebrew setup." >&2
fi

# NVM (Node Version Manager) installation
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" |
        PROFILE="$HOME/$BASH_ENV" bash
    echo node > $HOME/.nvmrc
    source $HOME/.nvm/nvm.sh

    nvm install $NODE_VERSION
    npm install -g @anthropic-ai/claude-code
else
    echo "NVM is already installed. Skipping NVM setup." >&2
fi

# Rust Lang installation
if [ ! -d "$HOME/.cargo" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --verbose -y

    sed -i '/\. "\$HOME\/\.cargo\/env"/d' ~/.bashrc
    echo "source $HOME/.cargo/env" >> $HOME/$BASH_ENV
else
    echo "Rust is already installed. Skipping Rust setup." >&2
fi
