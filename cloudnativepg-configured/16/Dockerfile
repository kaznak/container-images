FROM ghcr.io/cloudnative-pg/postgis:16

USER root

# Do not split the description, otherwise we will see a blank space in the labels
LABEL name="PostgreSQL + PostGIS + Some Extensions Container Images" \
      vendor="The CloudNativePG Contributors" \
      version="${PG_VERSION}" \
      release="30" \
      summary="PostgreSQL + Some Extensions Container images." \
      description="This Docker image contains PostgreSQL, Barman Cloud based and some extensions on Postgres 16"

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
# # https://github.com/EnterpriseDB/pldebugger
RUN apt-get update \
    && apt-get install -y unzip wget make gcc patch \
    && wget https://github.com/EnterpriseDB/pldebugger/archive/refs/tags/v1.8.zip    \
    && unzip v1.8.zip \
    && cd pldebugger-1.8 \
    && make \
    && make install \
    # && make installcheck    \ # if server is not running, installcheck fails.
    && cd .. \
    && rm -rf pldebugger-1.8/ v1.8.zip \
    && apt-get remove -y unzip wget patch make gcc patch \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install pg_cron
RUN apt-get update \
    && apt-get install -y postgresql-16-cron \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install multicorn2
RUN apt-get update  \
    && apt-get install -y   \
        wget clang-11   \
        build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc   \
        postgresql-server-dev-16    \
        python3 python3-dev python3-setuptools python3-pip  \
    && wget https://github.com/pgsql-io/multicorn2/archive/refs/tags/v2.5.tar.gz    \
    && tar -xvf v2.5.tar.gz \
    && cd multicorn2-2.5    \
    && make \
    && make install \
    && cd ..    \
    && rm -rf v2.5.tar.gz multicorn2-2.5    \
    && apt-get remove -y \
        wget clang-11   \
        build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc   \
        postgresql-server-dev-16    \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Install timescaledb 2.x
RUN apt-get update \
    && apt-get install -y lsb-release wget \
    && echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" | tee /etc/apt/sources.list.d/timescaledb.list \
    && wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add - \
    && apt-get update \
    && apt-get install -y "timescaledb-2-postgresql-${PG_MAJOR}" "timescaledb-toolkit-postgresql-${PG_MAJOR}" \
    && apt-get remove -y lsb-release wget \
    && apt-get autoremove -y \
    && apt-get clean \
    && echo /tmp/* /var/lib/apt/lists/* | xargs rm -rf

# Change the uid of postgres to 26
USER 26
