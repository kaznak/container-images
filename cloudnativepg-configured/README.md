# CloudNativePG Configured

A PostgreSQL image for [CloudNativePG](https://cloudnative-pg.io/) Cluster
with some locales and extensions.

Base image: [CloudNativePG PostGIS image](https://github.com/cloudnative-pg/postgis-containers)

## Locales

- ja_JP.UTF-8

## Extensions

### [CloudNativePG base image](https://github.com/cloudnative-pg/postgres-containers)

### [PostGIS](https://github.com/postgis/postgis)
- Came from [CloudNativePG PostGIS image](https://github.com/cloudnative-pg/postgis-containers)

### [TimescaleDB](https://www.timescale.com/) with [TimescaleDB Toolkit](https://docs.timescale.com/timescaledb/latest/how-to-guides/install-timescaledb-toolkit/)([src](https://github.com/timescale/timescaledb-toolkit))
- [Install TimescaleDB on Linux](https://docs.timescale.com/self-hosted/latest/install/installation-linux/)

### [pg_cron](https://github.com/citusdata/pg_cron)

### [pgTAP](https://pgtap.org/)

### [pldebugger](https://github.com/EnterpriseDB/pldebugger)

### [multicorn2](https://github.com/pgsql-io/multicorn2)

## How to use

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: cloudnativepg
spec:
  monitoring:
    enablePodMonitor: true
  instances: 1
  imageName: ghcr.io/kaznak/cloudnativepg-configured:16
  primaryUpdateStrategy: unsupervised
  bootstrap:
    initdb:
      postInitTemplateSQL:
        - CREATE EXTENSION timescaledb;
        - CREATE EXTENSION timescaledb_toolkit;
        - CREATE EXTENSION postgis;
        - CREATE EXTENSION postgis_topology;
        - CREATE EXTENSION fuzzystrmatch;
        - CREATE EXTENSION postgis_tiger_geocoder;
  postgresql:
    shared_preload_libraries:
      - timescaledb
  storage:
    size: 40Gi
```

## References

based on:

- [cloudnative-pg/postgis-containers](https://github.com/cloudnative-pg/postgis-containers)
- [imusmanmalik/cloudnative-pg-timescaledb-postgis-containers](https://github.com/imusmanmalik/cloudnative-pg-timescaledb-postgis-containers)
