FROM ubuntu:latest

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

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

RUN git clone https://github.com/Homebrew/brew /home/ubuntu/.linuxbrew \
 && eval "$(/home/ubuntu/.linuxbrew/bin/brew shellenv)" \
 && brew update --force --quiet \
 && chmod -R go-w "$(brew --prefix)/share/zsh" \
 && brew install \
    kubectl \
    helm \
    kustomize \
    helmfile \
    sops \
    age \
    uv  \
 && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc \
 && helm plugin install https://github.com/databus23/helm-diff \
 && helm plugin install https://github.com/aslafy-z/helm-git \
 && helm plugin install https://github.com/hypnoglow/helm-s3.git \
 && helm plugin install https://github.com/jkroepke/helm-secrets

# NVM (Node Version Manager) installation
ENV BASH_ENV=/home/ubuntu/.bash_env
ENV NVM_VERSION=v0.40.3
ENV NVM_DIR=/home/ubuntu/.nvm
ENV NODE_VERSION=20

RUN echo '. "${BASH_ENV}"' >> ~/.bashrc
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh"  \
  | PROFILE="${BASH_ENV}" bash \
 && echo node > /home/ubuntu/.nvmrc
RUN source $NVM_DIR/nvm.sh \
 && nvm install $NODE_VERSION \
 && npm install -g @anthropic-ai/claude-code 

USER root

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Copy default home directory contents if the home directory is empty
RUN cp -rp /home/ubuntu/. /home/ubuntu-home-backup

WORKDIR /home/ubuntu
ENV WORKDIR=/home/ubuntu

# Command to run the MCP server
ENTRYPOINT ["/entrypoint.sh", "ubuntu"]
CMD ["bash"]
