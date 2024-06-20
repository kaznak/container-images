#!/bin/sh

set -e
set -u

# setup ssh
mkdir ~/.ssh
echo "${GIT_SSH_KEY}"    > ~/.ssh/id
chmod -R go-rwx ~/.ssh

# clone app
git clone "${GIT_REPOSITORY}" app
cd app

# build and install
npm install --verbose
npm run build
npm install --omit dev

# run
if [ "$@" ] ; then
    exec npm run "$@"
else
    case "$NODE_ENV" in
        production)
            exec npm run start
            ;;
        # development)
        *)
            exec npm run dev
            ;;
    esac
fi
