# PostgreSQL

To use pgAgent, run pgAgent image as sidecar container.

## Stack
- [PostgreSQL](https://www.postgresql.org/)
    - [official image](https://hub.docker.com/_/postgres)
- Extensions
    - [pgroonga](https://pgroonga.github.io/)
        - extension name: pgroonga
        - PGroonga (píːzí:lúnɡά) is a PostgreSQL extension to use Groonga as the index. PostgreSQL supports full text search against languages that use only alphabet and digit. It means that PostgreSQL doesn't support full text search against Japanese, Chinese and so on. You can use super fast full text search feature against all languages by installing PGroonga into your PostgreSQL!
    - [pgvector](https://github.com/pgvector/pgvector)
        - extension name: vector
        - Open-source vector similarity search for Postgres.
    - [EnterpriseDB/pldebugger](https://github.com/EnterpriseDB/pldebugger)
        - extension name: pldbgapi
        - Procedural Language Debugger Plugin for PostgreSQL and EDB Postgres Advanced Server

## Not included

- Tools
    - [pgAdmin](https://www.pgadmin.org/)
    - [pgFormatter](https://sqlformat.darold.net/)([src](https://github.com/darold/pgFormatter))
        - A PostgreSQL SQL syntax beautifier that can work as a console program or as a CGI.
    - [sqitch](https://sqitch.org/)
- Extensions
    - [pgTAP](https://pgtap.org/)
    - [pgAudit](https://github.com/pgaudit/pgaudit)
        - [2020.11.25 pgAudit (PostgreSQL 監査ロギングツール)](https://www.sraoss.co.jp/tech-blog/pgsql/pgaudit/)
    - [pgAgent](https://www.pgadmin.org/docs/pgadmin4/6.18/pgagent.html)
        - [download pgAgent](https://www.pgadmin.org/download/#:~:text=Windows-,pgAgent,-pgAgent%20is%20a)
        - [pgAgentでジョブを定期実行する](https://lets.postgresql.jp/documents/technical/pgagent/1)
    - [pg_ivm](https://github.com/sraoss/pg_ivm)
        - IVM (Incremental View Maintenance) implementation as a PostgreSQL extension
        - [2022.12.23 PostgreSQL のマテリアライズドビューを高速に最新化する](https://www.sraoss.co.jp/tech-blog/pgsql/postgresql_ivm/)
    - [michelp/pgjwt: PostgreSQL implementation of JWT (JSON Web Tokens)](https://github.com/michelp/pgjwt)
        - PostgREST requires this.

## Related

- [The PostgreSQL Wiki](https://wiki.postgresql.org/wiki/Main_Page)
- [PGXN: PostgreSQL Extension Network](https://pgxn.org/)
    - [about](https://pgxn.org/about/)
    - [in the PostgreSQL Wiki](https://wiki.postgresql.org/wiki/PGXN)
    - [PGXN Client’s documentation](https://pgxn.github.io/pgxnclient/index.html)([src](https://github.com/pgxn/pgxnclient))
