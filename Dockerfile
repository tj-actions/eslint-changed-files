FROM alpine:3.11

LABEL maintainer="Tonye Jack <jtonye@ymail.com>"

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh grep npm
    
RUN npm install -g npx

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
