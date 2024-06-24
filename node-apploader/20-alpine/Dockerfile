FROM node:20-alpine

LABEL name="Node application loader" \
      vendor="kaznak" \
      version="20-alpine" \
      summary="Node that load, install, build and start a project."

RUN apk update \
    && apk add --no-cache git openssh \
    && apk cache clean

USER node

WORKDIR /home/node

RUN mkdir ~/.ssh
RUN ssh-keyscan github.com | tee ~/.ssh/known_hosts
RUN chmod -R go-rwx ~/.ssh

COPY ./entrypoint.sh .

ENV GIT_REPOSITORY=
ENV GIT_BRANCH=main
ENV GIT_SSH_KEY=
ENV NPM=npm
ENV NODE_ENV=production

ENTRYPOINT [ "/home/node/entrypoint.sh" ]
