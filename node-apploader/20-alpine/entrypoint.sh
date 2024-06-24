#!/bin/sh

set -Cu
set -e

# setup ssh
mkdir -p ~/.ssh
if [ "dummy" != "${GIT_SSH_KEY:-"dummy"}" ] ; then
    echo "${GIT_SSH_KEY}"    > ~/.ssh/id_rsa
    chmod -R go-rwx ~/.ssh
fi

set -vx

# clone app
if [ "dummy" = "${GIT_REPOSITORY:-"dummy"}" ] ; then
    exit 1
fi
git clone "${GIT_REPOSITORY}" app
cd app
git switch "${GIT_BRANCH:-"main"}"

# check package manager
if [ -s "./package-lock.json" ] ; then
    NPM=${NPM:-"npm"}
elif [ -s "./yarn.lock" ] ; then
    NPM=${NPM:-"yarn"}
elif [ -s "./pnpm-lock.yaml" ] ; then
    NPM=${NPM:-"pnpm"}
else
    echo "not supported package manager" >&2
    exit 1
fi

case "$NPM" in
    yarn)
        corepack enable yarn
        echo "yarn does not supported" >&2
        exit 1
        ;;
    pnpm)
        corepack enable pnpm
        echo "pnpm does not supported" >&2
        exit 1
        ;;
    # npm)
    *)
        # build and install
        npm install --verbose --include dev
        npm run build

        # run
        if [ "$@" ] ; then
            exec npm run "$@"
        else
            case "$NODE_ENV" in
                production)
                    npm install --omit dev
                    git log -1 --format='%H'
                    exec npm run start
                    ;;
                # development)
                *)
                    git log -1 --format='%H'
                    exec npm run dev
                    ;;
            esac
        fi
        ;;
esac
