#!/bin/bash

set-eo pipefail
shopt -s nullglob

source /entrypoint.sh
exec _main --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --transaction-isolation=READ-COMMITTED --enforce-gtid-consistency=ON "$@"
