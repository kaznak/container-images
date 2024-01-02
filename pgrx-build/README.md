# pgrx build environment

- [pgrx](https://github.com/pgcentralfoundation/pgrx)

## Usage

- mount source tree to `/checkout`
- the builder user is `rust:rust` (default, uid: 1000, gid: 1000)
- user mapping feature is implemented. the `rust:rust` user in the container is mapped to the host user.
