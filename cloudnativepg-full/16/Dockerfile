FROM postgis/postgis:16-3.4 as builder

# Install timescaledb 2.x
RUN apt-get update \
    && apt-get install -y lsb-release wget \
    && echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" | tee /etc/apt/sources.list.d/timescaledb.list \
    && wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add - \
    && apt-get update \
    && apt-get install -y "timescaledb-2-postgresql-${PG_MAJOR}" \
    && apt-get remove -y lsb-release wget \
    && 	rm -fr /tmp/* \
    && 	rm -rf /var/lib/apt/lists/*

FROM ghcr.io/cloudnative-pg/postgis:16

# Do not split the description, otherwise we will see a blank space in the labels
LABEL name="PostgreSQL + PostGIS + Some Extensions Container Images" \
      vendor="The CloudNativePG Contributors" \
      version="${PG_VERSION}" \
      release="16" \
      summary="PostgreSQL + Some Extensions Container images." \
      description="This Docker image contains PostgreSQL, Barman Cloud based and some extensions on Postgres 16"

COPY --from=builder / /
