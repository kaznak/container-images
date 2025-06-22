#!/bin/bash

set -euo pipefail

NODE_VERSION=20

# Install homebrew packages
# eval "$($HOME/.linuxbrew/bin/brew shellenv)"
brew install \
    kubectl \
    helm \
    kustomize \
    helmfile \
    sops \
    age \
    uv  \
    talosctl

helm plugin install https://github.com/databus23/helm-diff || true
helm plugin install https://github.com/aslafy-z/helm-git || true
helm plugin install https://github.com/hypnoglow/helm-s3.git || true
helm plugin install https://github.com/jkroepke/helm-secrets || true

# Install Node.js and npm
# source $HOME/.nvm/nvm.sh
nvm install $NODE_VERSION
npm install -g @anthropic-ai/claude-code 

# source $HOME/.cargo/env
rustup default stable
rustup component add rustfmt clippy
cargo install cargo-edit cargo-watch

