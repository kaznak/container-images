FROM debian:trixie

ARG PG_MAJOR_VERSION
ENV PG_MAJOR_VERSION=${PG_MAJOR_VERSION}

ARG PGRX_VERSION
ENV PGRX_VERSION=${PGRX_VERSION}

ARG YQ_VERSION
ENV YQ_VERSION=${YQ_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y wget gnupg
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trixie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update -y --fix-missing
RUN apt-get install -y \
  sudo  \
  build-essential \
  curl \
  clang \
  git \
  gcc \
  libssl-dev \
  libz-dev \
  make \
  pkg-config \
  postgresql-$PG_MAJOR_VERSION \
  postgresql-server-dev-$PG_MAJOR_VERSION \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/yq-install && \
    cd /tmp/yq-install && \
    wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64.tar.gz -O - |  \
    tar xz && \
    mv yq_linux_amd64 /usr/bin/yq && \
    chmod 755 /usr/bin/yq &&  \
    bash install-man-page.sh && \
    cd /root && \
    rm -rf /tmp/yq-install

# Set up permissions so that the rust user below can create extensions
RUN chmod a+rwx `$(which pg_config) --pkglibdir` \
  `$(which pg_config) --sharedir`/extension \
  /var/run/postgresql/

# Running pgrx and tests require a non-root user
RUN useradd --create-home --shell /bin/bash rust
RUN echo "rust ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rust

WORKDIR /checkout
RUN chown -R rust:rust /checkout
COPY --chown=rust:rust . /checkout

USER rust

# This environment variable is required for postgres while running the tests
ENV USER=rust

# Install cargo and Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/rust/.cargo/bin:${PATH}"

# By default, we always want to use '--locked'. However, there are some circumstances
# where we might want to try it unlocked. In those one-off scenarios, the image
# can be built by docker with: --build-arg CARGO_LOCKED_OPTION=''
ARG CARGO_LOCKED_OPTION='--locked'
ENV CARGO_LOCKED_OPTION=${CARGO_LOCKED_OPTION}

# Install cargo-pgrx from source copied into this container
RUN echo "Running cargo install --version =${PGRX_VERSION} --force cargo-pgrx $CARGO_LOCKED_OPTION" \
    && cargo install --version =${PGRX_VERSION} --force cargo-pgrx $CARGO_LOCKED_OPTION

# Initialize cargo pgrx so that we can run the tests
RUN cargo pgrx init --pg$PG_MAJOR_VERSION=$(which pg_config)

# Run as root to map host user to container user
USER root
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
