
ARG PG_MAJOR_VERSION
ARG PGTAP_VERSION
ARG PLDEBUGGER_VERSION
ARG MULTICORN2_VERSION
ARG PGROONGA_VERSION
ARG PGXUUIDV7_VERSION

FROM ghcr.io/cloudnative-pg/postgresql:${PG_MAJOR_VERSION}-standard-trixie
# FROM ghcr.io/cloudnative-pg/postgis:${PG_MAJOR_VERSION}

USER root

# Do not split the description, otherwise we will see a blank space in the labels
LABEL name="PostgreSQL + PostGIS + Some Extensions Container Images" \
      vendor="Th0e CloudNativePG Contributors" \
      version="${PG_MAJOR_VERSION}" \
      release="30" \
      summary="PostgreSQL + Some Extensions Container images." \
      description="This Docker image contains PostgreSQL, Barman Cloud based and some extensions on Postgres ${PG_MAJOR_VERSION}"

# build locale
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8

# Install pgTAP
RUN apt-get update \
    && apt-get install -y unzip wget make gcc patch \
    && wget https://github.com/theory/pgtap/releases/download/v${PGTAP_VERSION}/pgTAP-${PGTAP_VERSION}.zip    \
    && unzip pgTAP-${PGTAP_VERSION}.zip \
    && cd pgTAP-${PGTAP_VERSION} \
    && make \
    && make install \
    # && make installcheck    \ # if server is not running, installcheck fails.
    && cd .. \
    && rm -rf pgTAP-${PGTAP_VERSION} pgTAP-${PGTAP_VERSION}.zip \
    && apt-get remove -y unzip wget patch make gcc patch \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install pldebugger
RUN apt-get update \
    && apt-get install -y postgresql-${PG_MAJOR_VERSION}-pldebugger \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install pg_cron
RUN apt-get update \
    && apt-get install -y postgresql-${PG_MAJOR_VERSION}-cron \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install multicorn2
RUN apt-get update  \
    && apt-get install -y   \
        wget clang   \
        build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc   \
        postgresql-server-dev-${PG_MAJOR_VERSION}    \
        python3 python3-dev python3-setuptools python3-pip  \
    && wget https://github.com/pgsql-io/multicorn2/archive/refs/tags/v${MULTICORN2_VERSION}.tar.gz    \
    && tar -xvf v${MULTICORN2_VERSION}.tar.gz \
    && cd multicorn2-${MULTICORN2_VERSION}    \
    && make \
    && make install \
    && cd ..    \
    && rm -rf v${MULTICORN2_VERSION}.tar.gz multicorn2-${MULTICORN2_VERSION}    \
    && apt-get remove -y \
        wget clang   \
        build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc   \
        postgresql-server-dev-${PG_MAJOR_VERSION}    \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install timescaledb 2.x and toolkit
# Note: The base image is Debian 11 (Bullseye)
RUN apt-get update \
    && apt-get install -y lsb-release curl \
    && curl -s https://packagecloud.io/install/repositories/timescale/timescaledb/script.deb.sh | bash \
    && apt-get update \
    && apt-get install -y "timescaledb-2-postgresql-${PG_MAJOR_VERSION}" "timescaledb-toolkit-postgresql-${PG_MAJOR_VERSION}" \
    && apt-get remove -y lsb-release curl \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /etc/apt/sources.list.d/timescaledb.list  \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install pgroonga (build from source)
RUN apt-get update \
    && apt-get install -y ca-certificates lsb-release wget build-essential \
    && wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb \
    && apt-get install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb \
    && rm groonga-apt-source-latest-$(lsb_release --codename --short).deb \
    && apt-get update \
    && apt-get install -y \
        postgresql-server-dev-${PG_MAJOR_VERSION} \
        libgroonga-dev \
        pkg-config \
        libmsgpack-dev \
        groonga-token-filter-stem \
        groonga-tokenizer-mecab \
    && wget https://packages.groonga.org/source/pgroonga/pgroonga-${PGROONGA_VERSION}.tar.gz \
    && tar xvf pgroonga-${PGROONGA_VERSION}.tar.gz \
    && cd pgroonga-${PGROONGA_VERSION} \
    && make HAVE_MSGPACK=1 \
    && make install \
    && cd .. \
    && rm -rf pgroonga-${PGROONGA_VERSION}.tar.gz pgroonga-${PGROONGA_VERSION} \
    && apt-get remove -y lsb-release wget build-essential postgresql-server-dev-${PG_MAJOR_VERSION} libgroonga-dev pkg-config libmsgpack-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install ProvSQL
RUN apt-get update \
    && apt-get install -y \
        git build-essential \
        postgresql-server-dev-${PG_MAJOR_VERSION} \
        libboost-dev libboost-serialization-dev \
        uuid-dev \
    && git clone --depth 1 https://github.com/PierreSenellart/provsql.git \
    && cd provsql \
    && make \
    && make install \
    && cd .. \
    && rm -rf provsql \
    && apt-get remove -y git build-essential postgresql-server-dev-${PG_MAJOR_VERSION} libboost-dev libboost-serialization-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install pgvector packages
RUN yes | /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh   \
    && apt-get update   \
    && apt-get install -y postgresql-${PG_MAJOR_VERSION}-pgvector    \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install pgx_uuidv7
RUN apt-get update \
    && apt-get install -y wget \
    && wget -O /tmp/pgx-uuidv7-${PG_MAJOR_VERSION}-amd64-linux-gnu.deb \
        https://github.com/kaznak/pgx_uuidv7/releases/download/v${PGXUUIDV7_VERSION}/pgx-uuidv7-${PG_MAJOR_VERSION}-amd64-linux-gnu.deb \
    && dpkg -i /tmp/pgx-uuidv7-${PG_MAJOR_VERSION}-amd64-linux-gnu.deb \
    && rm /tmp/pgx-uuidv7-${PG_MAJOR_VERSION}-amd64-linux-gnu.deb \
    && apt-get remove -y wget \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Change the uid of postgres to 26
USER 26
