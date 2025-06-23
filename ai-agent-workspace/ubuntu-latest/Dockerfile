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

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY setup-environment /setup-environment

# Command to run the MCP server
ENTRYPOINT ["/entrypoint.sh", "ubuntu"]
CMD ["bash"]
