#!/usr/bin/env bash
#
# example usage:
#   cat \
#     cloudnativepg-configured/16/strategy.json \
#     cloudnativepg-configured/16/strategy.json \
#   | .github/generate-strategy.sh 
#

set -eu

repository_with_trailing_slash=$1

jq '
. as $root |
{
    tags: [$root.variant],
    tagsProcessed: (($root.tags // [$root.variant]) | map("'$repository_with_trailing_slash'\($root.imgname):\(.)")),
    platforms: ($root.platforms // ["linux/amd64"]),
    dir: ($root.imgname + "/" + $root.variant),
    files: {
        dockerfile: "Dockerfile",
        dockleignore: ".dockleignore"
    },
    buildArgs: {}
} as $defaults |
{
    name: $root.name,
    imgname: $root.imgname,
    variant: $root.variant,
    tags: ($root.tags // $defaults.tags),
    tagsProcessed: ($root.tagsProcessed // $defaults.tagsProcessed),
    platforms: ($root.platforms // $defaults.platforms),
    dir: ($root.dir // $defaults.dir),
    files: {
        dockerfile: ($root.files.dockerfile // $defaults.files.dockerfile),
        dockleignore: ($root.files.dockleignore // $defaults.files.dockleignore)
    },
    filesProcessed: {
        dockerfile: (($root.dir // $defaults.dir) + "/" + ($root.files.dockerfile // $defaults.files.dockerfile)),
        dockleignore: (($root.dir // $defaults.dir) + "/" + ($root.files.dockleignore // $defaults.files.dockleignore))
    },
    buildArgs: ($root.buildArgs // $defaults.buildArgs),
    buildArgsProcessed: (($root.buildArgs // $defaults.buildArgs) | to_entries | map("\(.key)=\(.value)") | join("\n"))
}
'   |
jq -s .
