#!/usr/bin/env bash
#
# example usage:
#  cat  cloudnativepg-configured/16/strategy.json  cloudnativepg-configured/16/strategy.json | .github/generate-strategy.sh 
#

set -eu

jq '
. as $root |
.platforms | .[] |
{
    name: $root.name,
    version: $root.version,
    platform: .,
    imgname: $root.imgname,
    tags: $root.tags,
    dir: $root.dir,
    file: $root.file,
}
'   |
jq -s '
{
    "fail-fast": false,
    "matrix": {
        "include": .,
    },
}
'
