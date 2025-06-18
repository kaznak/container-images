FROM ubuntu:latest

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

ENV DEFAULT_USER=ubuntu

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

# Copy default home directory contents if the home directory is empty
RUN cp -rp /home/$DEFAULT_USER/. /home/$DEFAULT_USER-home-backup

WORKDIR /home/$DEFAULT_USER
ENV WORKDIR=/home/$DEFAULT_USER

# Command to run the MCP server
ENTRYPOINT ["/entrypoint.sh", "$DEFAULT_USER"]
CMD ["bash"]
