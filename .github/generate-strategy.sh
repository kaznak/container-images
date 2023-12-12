#!/usr/bin/env bash
#
# example usage:
#  cat  cloudnativepg-configured/16/strategy.json  cloudnativepg-configured/16/strategy.json | .github/generate-strategy.sh 
#

set -eu

jq '
. as $root |
($root.dir // $root.imgname + "/" + $root.version) as $dir |
{
    platforms: ($root.platforms // ["linux/amd64"]),
    tags: ($root.tags // [$root.version]),
    dir: $dir,
    files: {
        dockerfile: ($dir + "/Dockerfile"),
        dockleignore: ($dir + "/.dockleignore")
    }
} as $defaults |
.platforms // $defaults.platforms | .[] | . as $platform |
{
    name: $root.name,
    version: $root.version,
    platform: $platform,
    imgname: $root.imgname,
    tags: ($root.tags // $defaults.tags),
    dir: ($root.dir // $defaults.dir),
    files: {
        dockerfile: ($root.files.dockerfile // $defaults.files.dockerfile),
        dockleignorefile: ($root.files.dockleignore // $defaults.files.dockleignore)
    }
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
