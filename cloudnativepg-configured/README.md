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

https://pgsqldeepdive.blogspot.com/2013/05/plpgsqldebugger.html

pgadmin4 のヘルプにデバッガの使い方についての記載がある。

スーパーユーザーでないと create extension できない

スーパーユーザーでないとブレークポイントの設定が出来ない

### [multicorn2](https://github.com/pgsql-io/multicorn2)

### [PGroonga](https://pgroonga.github.io/ja/)

インストール:

- https://pgroonga.github.io/ja/install/

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
        - CREATE EXTENSION pg_cron;
        - CREATE EXTENSION pldbgapi;
  postgresql:
    shared_preload_libraries:
      - timescaledb
      - pg_cron
      - plugin_debugger
    pg_ident:
      - local postgres app_owner
    parameters:
      "pgaudit.log": "all, -misc"
      "pgaudit.log_catalog": "off"
      "pgaudit.log_parameter": "on"
      "pgaudit.log_relation": "on"
      #
      "cron.host": ""
      "cron.database_name": "app"
      "cron.timezone": "JST"
  storage:
    size: 40Gi
```

## References

based on:

- [cloudnative-pg/postgis-containers](https://github.com/cloudnative-pg/postgis-containers)
- [imusmanmalik/cloudnative-pg-timescaledb-postgis-containers](https://github.com/imusmanmalik/cloudnative-pg-timescaledb-postgis-containers)
