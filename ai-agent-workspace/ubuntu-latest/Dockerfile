FROM ubuntu:latest

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_VERSION=v0.40.3
ENV NVM_DIR=/home/ubuntu/.nvm
ENV NODE_VERSION=20

WORKDIR /home/ubuntu
ENV WORKDIR=/home/ubuntu
ENV BASH_ENV=/home/ubuntu/.bash_env

# Install basic utilities and dependencies
RUN apt-get update && apt-get install -y \
    tzdata \
    curl \
    wget \
    git \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    unzip \
    zip \
    vim \
    nano \
    jq \
    stow \
    iputils-ping \
    dnsutils \
    net-tools \
    python3 \
    python3-pip \
    ssh \
    openssl \
    build-essential \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER ubuntu

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN touch $HOME/.bash_env && echo '. $HOME/.bash_env' >> $HOME/.bashrc

RUN git clone https://github.com/Homebrew/brew $HOME/.linuxbrew \
 && eval "$($HOME/.linuxbrew/bin/brew shellenv)" \
 && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_env \
 && brew update --force --quiet \
 && chmod -R go-w "$(brew --prefix)/share/zsh"

# NVM (Node Version Manager) installation
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh"  \
  | PROFILE="$HOME/.bash_env" bash \
 && echo node > $HOME/.nvmrc
RUN source $HOME/.nvm/nvm.sh \
 && nvm install $NODE_VERSION \
 && npm install -g @anthropic-ai/claude-code

# Rust Lang installation
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --verbose -y \
 && sed -i '/\. "\$HOME\/\.cargo\/env"/d' ~/.bashrc \
 && echo "source $HOME/.cargo/env" >> $HOME/.bash_env

USER root

# Copy default home directory contents if the home directory is empty
RUN cp -rp /home/ubuntu /home/ubuntu-home-backup && rm -rf /home/ubuntu/* /home/ubuntu/.*

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY setup-environment /setup-environment

# Command to run the MCP server
ENTRYPOINT ["/entrypoint.sh", "ubuntu"]
CMD ["bash"]
