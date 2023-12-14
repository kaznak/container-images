#!/usr/bin/env bash
#
# example usage:
#  cat \
#      cloudnativepg-configured/16/strategy.json \
#      cloudnativepg-configured/16/strategy.json \
#  | .github/generate-strategy.sh \
#  | jq -c '.matrix.include|.[]'  \
#  | .github/matrix-to-tag.sh
#

set -eu

repository=$1

jq -r '
.imgname as $name |
.tags | .[] | . as $tag |
"'$repository'/\($name):\($tag)"' |
tr '\n' ',' |
sed -e 's/^/TAGS=/' -e 's/,$/\n/'
