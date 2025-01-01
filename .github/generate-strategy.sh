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
    tags: ($root.tags // [$root.variant]),
    dir: ($root.dir // $root.imgname + "/" + $root.variant),
    files: {
        dockerfile: ($root.files.dockerfile // "Dockerfile"),
        dockleignore: ($root.files.dockleignore //  ".dockleignore")
    },
    buildArgs: ($root.buildArgs // {})
} as $step1 |
{
    name: $root.name,
    imgname: $root.imgname,
    variant: $root.variant,
    tags: $step1.tags,
    tagsProcessed: ($step1.tags | map("'$repository_with_trailing_slash'\($root.imgname):\(.)")),
    platforms: ($root.platforms // ["linux/amd64"]),
    dir: $step1.dir,
    files: {
        dockerfile: $step1.files.dockerfile,
        dockleignore: $step1.files.dockleignore
    },
    filesProcessed: {
        dockerfile: ($step1.dir + "/" + $step1.files.dockerfile),
        dockleignore: ($step1.dir + "/" + $step1.files.dockleignore)
    },
    buildArgs: $step1.buildArgs,
    buildArgsProcessed: ($step1.buildArgs | to_entries | map("\(.key)=\(.value)") | join("\n"))
}
'   |
jq -s .
