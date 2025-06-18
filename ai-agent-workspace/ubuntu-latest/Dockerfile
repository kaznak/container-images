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

# linuxbrew
RUN curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
    | bash -s -- --unattended \
 && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
 && brew update \
 && brew install \
    kubectl \
    helm \
    kustomize \
    helmfile \
    sops \
    age \
    uv  \
    anyenv

USER ubuntu

RUN test -d /home/linuxbrew/.linuxbrew &&   \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" &&   \
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
RUN helm plugin install https://github.com/databus23/helm-diff
RUN helm plugin install https://github.com/aslafy-z/helm-git
RUN helm plugin install https://github.com/hypnoglow/helm-s3.git
RUN helm plugin install https://github.com/jkroepke/helm-secrets

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
