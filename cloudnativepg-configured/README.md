# CloudNativePG Configured

A PostgreSQL image for [CloudNativePG](https://cloudnative-pg.io/) Cluster
with some locales and extensions.

Base image: [CloudNativePG PostGIS image](https://github.com/cloudnative-pg/postgis-containers)

- or [CloudNativePG standard image](https://github.com/cloudnative-pg/postgres-containers)

## Locales

- ja_JP.UTF-8

## Extensions

### [CloudNativePG base image](https://github.com/cloudnative-pg/postgres-containers)

### [PostGIS](https://github.com/postgis/postgis)
- Came from [CloudNativePG PostGIS image](https://github.com/cloudnative-pg/postgis-containers)

### [TimescaleDB](https://www.timescale.com/) with [TimescaleDB Toolkit](https://docs.timescale.com/timescaledb/latest/how-to-guides/install-timescaledb-toolkit/)([src](https://github.com/timescale/timescaledb-toolkit))
- [Install TimescaleDB on Linux](https://docs.timescale.com/self-hosted/latest/install/installation-linux/)

### [pg_cron](https://github.com/citusdata/pg_cron)

### [pgmq](https://pgmq.github.io/pgmq/)([src](https://github.com/pgmq/pgmq))

シンプルなメッセージキュー。

ワーカーからの使用方法の例:

1. メッセージを pop → メッセージに Visibility Timeout が設定される。
2. 処理を開始
3. 処理中に適宜 set_vt を実行して Visibility Timeout を延長
4. 処理が完了したら delete もしくは archive でメッセージを無効化

ワーカーの処理は冪等である必要がある。

### [pgTAP](https://pgtap.org/)

### [pldebugger](https://github.com/EnterpriseDB/pldebugger)

https://pgsqldeepdive.blogspot.com/2013/05/plpgsqldebugger.html

pgadmin4 のヘルプにデバッガの使い方についての記載がある。

スーパーユーザーでないと create extension できない

スーパーユーザーでないとブレークポイントの設定が出来ない

### [multicorn2](https://github.com/pgsql-io/multicorn2)

FDW 作成のためのフレームワーク。
利用例は [python/multicorn](https://github.com/pgsql-io/multicorn2/tree/main/python/multicorn) を参照。
pg17 のイメージでは、 `/usr/local/lib/python3.9/dist-packages/` 以下にインストールされる。

### [PGroonga](https://pgroonga.github.io/ja/)

インストール:

- https://pgroonga.github.io/ja/install/

### [ProvSQL](https://github.com/PierreSenellart/provsql)

PostgreSQL用のprovenance（データ来歴）とuncertainty（不確実性）管理機能を提供する拡張機能。

主な機能:
- Boolean and semiring provenance computation
- Probability computation  
- Shapley value computation
- Provenance tracking of updates

使用方法:
- `CREATE EXTENSION provsql;` でエクステンションを有効化
- `SELECT provsql.add_provenance('テーブル名'::regclass);` でテーブルにprovenanceを追加

### [pgx-uuidv7](https://github.com/kaznak/pgx_uuidv7)

### [uuidv47](https://github.com/stateless-me/uuidv47)

uuidv7 を uuidv4 に相互変換する。変換過程は暗号学的に安全。

使用例:

```
SET uuid47.key = '0011223344556677:8899aabbccddeeff';
select uuid_to_uuid47('0199d898-69f3-7dc1-a5b5-22dac6d50e15'::uuid)::uuid;
```

変換の為の鍵が設定されていないと変換が実行されない。
内部的に uuid47 という専用のデータ型を使用しており、 uuid へキャストする事で、 uuidv4 に変換される。

### [pgx-basex-codec](https://github.com/kaznak/pgx_basex_codec)

## How to use

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: cnpg0000
spec:
  enableSuperuserAccess: true
  monitoring:
    enablePodMonitor: true
  instances: 1
  imageName: ghcr.io/kaznak/cloudnativepg-configured:17
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
        - CREATE EXTENSION pldbgapi;
        - CREATE EXTENSION "uuid-ossp";
        - CREATE EXTENSION provsql;
      postInitApplicationSQL:
        - CREATE EXTENSION IF NOT EXISTS pg_cron;
  postgresql:
    shared_preload_libraries:
      - timescaledb
      - pg_cron
      - plugin_debugger
      - provsql
    pg_ident:
      - local postgres app
    parameters:
      "pgaudit.log": "all, -misc"
      "pgaudit.log_catalog": "off"
      "pgaudit.log_parameter": "on"
      "pgaudit.log_relation": "on"
      #
      "cron.host": ""
      "cron.database_name": "app"
      "cron.timezone": "Asia/Tokyo"
  storage:
    size: 40Gi
```

## References

based on:

- [cloudnative-pg/postgis-containers](https://github.com/cloudnative-pg/postgis-containers)
- [imusmanmalik/cloudnative-pg-timescaledb-postgis-containers](https://github.com/imusmanmalik/cloudnative-pg-timescaledb-postgis-containers)
