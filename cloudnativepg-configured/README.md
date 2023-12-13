# CloudNativePG Configured

A PostgreSQL image for [CloudNativePG](https://cloudnative-pg.io/) Cluster
with some extensions.

Extensions:

- CloudNativePG base image
- PostGIS(CloudNativePG image)
- [TimescaleDB](https://www.timescale.com/)
  - [Install TimescaleDB on Linux](https://docs.timescale.com/self-hosted/latest/install/installation-linux/)

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
