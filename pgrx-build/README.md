# pgrx build environment

- [pgrx](https://github.com/pgcentralfoundation/pgrx)

build environment for extensions based on pgrx.

pgrx gets the build target from pg_config, so it needs to be built with the image of the target to be installed.

## ⚠️ Version Support Notice

Postgres versions supported:
- 18
- 17

Pgrx versions supported:
- 0.16.1

## Usage

- mount source tree to `/checkout`
- the builder user is `rust:rust` (default, uid: 1000, gid: 1000)
- user mapping feature is implemented. the `rust:rust` user in the container is mapped to the host user.
