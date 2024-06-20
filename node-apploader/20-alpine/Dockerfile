FROM node:20-alpine

LABEL name="Node application loader" \
      vendor="kaznak" \
      version="20-alpine" \
      summary="Node that load, install, build and start a project."

RUN apk update --no-cache \
    && apk add git

USER node

WORKDIR /home/node

COPY ./entrypoint.npm.sh .

ENV GIT_REPOSITORY=
ENV GIT_SSH_KEY=
ENV NODE_ENV=development

ENTRYPOINT [ "entrypoint.npm.sh" ]
