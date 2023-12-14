#!/usr/bin/env bash
#
# example usage:
#  cat \
#      cloudnativepg-configured/16/strategy.json \
#      cloudnativepg-configured/16/strategy.json \
#  | .github/generate-strategy.sh myrepository/ \
#  | jq -c '.matrix.include|.[]'  \
#  | .github/matrix-to-tag.sh
#

set -eu

repository_with_trailing_slash=$1

jq -r '
.imgname as $name |
.tags | .[] | . as $tag |
"'$repository_with_trailing_slash'\($name):\($tag)"' |
tr '\n' ',' |
sed -e 's/^/TAGS=/' -e 's/,$/\n/'
