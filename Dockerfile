FROM alpine:3.11

LABEL maintainer="Tonye Jack <jtonye@ymail.com>"

RUN apk add  --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main/nodejs=10.14.2-r0

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh grep

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
