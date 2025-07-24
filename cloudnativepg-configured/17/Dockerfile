FROM ghcr.io/cloudnative-pg/postgis:17

USER root

# Do not split the description, otherwise we will see a blank space in the labels
LABEL name="PostgreSQL + PostGIS + Some Extensions Container Images" \
      vendor="The CloudNativePG Contributors" \
      version="${PG_VERSION}" \
      release="30" \
      summary="PostgreSQL + Some Extensions Container images." \
      description="This Docker image contains PostgreSQL, Barman Cloud based and some extensions on Postgres 17"

# build locale
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8

# Install pgTAP 1.3.3
RUN apt-get update \
    && apt-get install -y unzip wget make gcc patch \
    && wget https://github.com/theory/pgtap/releases/download/v1.3.3/pgTAP-1.3.3.zip    \
    && unzip pgTAP-1.3.3.zip \
    && cd pgTAP-1.3.3 \
    && make \
    && make install \
    # && make installcheck    \ # if server is not running, installcheck fails.
    && cd .. \
    && rm -rf pgTAP-1.3.3 pgTAP-1.3.3.zip \
    && apt-get remove -y unzip wget patch make gcc patch \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install pldebugger
RUN apt-get update \
    && apt-get install -y postgresql-17-pldebugger \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install pg_cron
RUN apt-get update \
    && apt-get install -y postgresql-17-cron \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install multicorn2
RUN apt-get update  \
    && apt-get install -y   \
        wget clang   \
        build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc   \
        postgresql-server-dev-${PG_MAJOR}    \
        python3 python3-dev python3-setuptools python3-pip  \
    && MULTICORN2_VERSION=3.0 \
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
        postgresql-server-dev-${PG_MAJOR}    \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install timescaledb 2.x and toolkit
# Note: The base image is Debian 11 (Bullseye)
RUN apt-get update \
    && apt-get install -y lsb-release curl \
    && curl -s https://packagecloud.io/install/repositories/timescale/timescaledb/script.deb.sh | bash \
    && apt-get update \
    && apt-get install -y "timescaledb-2-postgresql-${PG_MAJOR}" "timescaledb-toolkit-postgresql-${PG_MAJOR}" \
    && apt-get remove -y lsb-release curl \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /etc/apt/sources.list.d/timescaledb.list  \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install pgroonga
# # disabling because of following error # E: Unable to locate package postgresql-17-17-pgroonga
# RUN apt-get update  \
#     && apt-get install -y lsb-release wget \
#     && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -c -s)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
#     && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -    \
#     && apt-get update   \
#     && apt-get remove -y wget \
#     && apt install -y -V "postgresql-17-${PG_MAJOR}-pgroonga" "groonga-tokenizer-mecab" \
#     && apt-get remove -y lsb-release wget \
#     && apt-get clean \
#     && rm -rf /etc/apt/sources.list.d/pgdg.list \
#     && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install postgresql packages
RUN yes | /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh   \
    && apt-get update   \
    && apt-get install -y postgresql-17-pgvector    \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Change the uid of postgres to 26
USER 26
