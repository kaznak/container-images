# pgrx build environment

- [pgrx](https://github.com/pgcentralfoundation/pgrx)

build environment for extensions based on pgrx.

pgrx gets the build target from pg_config, so it needs to be built with the image of the target to be installed.

## ⚠️ Deprecation Notice

**Old pgrx versions are being phased out:**

- **Immediately discontinued**: pgrx 0.10.2, 0.11.2, 0.11.3
- **Scheduled for deprecation**: pgrx 0.11.4 (will be removed in 6-12 months)
- **Currently supported**: pgrx 0.14.3, 0.15.0

Please migrate to pgrx 0.14.3 or later for continued support.

## Usage

- mount source tree to `/checkout`
- the builder user is `rust:rust` (default, uid: 1000, gid: 1000)
- user mapping feature is implemented. the `rust:rust` user in the container is mapped to the host user.
