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
    dir: ($root.dir // $root.imgname + "/" + $root.variant),
    imgtags: ($root.imgtags // [$root.variant])
} as $tmp |
{
    platforms: ($root.platforms // ["linux/amd64"]),
    imgtags: $tmp.imgtags,
    tags: ($tmp.imgtags | map("'$repository_with_trailing_slash'\($root.imgname):\(.)")),
    dir: $tmp.dir,
    files: {
        dockerfile: ($tmp.dir + "/Dockerfile"),
        dockleignore: ($tmp.dir + "/.dockleignore")
    }
} as $defaults |
.platforms // $defaults.platforms | .[] | . as $platform |
{
    name: $root.name,
    variant: $root.variant,
    platform: $platform,
    imgname: $root.imgname,
    imgtags: $defaults.imgtags,
    tags: ($root.tags // $defaults.tags),
    dir: ($root.dir // $defaults.dir),
    files: {
        dockerfile: ($root.files.dockerfile // $defaults.files.dockerfile),
        dockleignore: ($root.files.dockleignore // $defaults.files.dockleignore)
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
