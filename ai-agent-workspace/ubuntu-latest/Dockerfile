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

RUN git clone https://github.com/anyenv/anyenv /home/ubuntu/.anyenv \
 && git clone https://github.com/znz/anyenv-update.git /home/ubuntu/.anyenv/plugins/anyenv-update \
 && echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bashrc

RUN /home/ubuntu/.anyenv/bin/anyenv init \
 && /home/ubuntu/.anyenv/bin/anyenv install --init \
 && /home/ubuntu/.anyenv/bin/anyenv install nodenv

RUN nodenv install 22.16.0 && nodenv global 22.16.0

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
