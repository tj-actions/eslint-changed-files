FROM alpine:3.14.2

LABEL maintainer="Tonye Jack <jtonye@ymail.com>"

ENV REVIEWDOG_VERSION="v0.13.0"

RUN apk add bash git wget openssh grep npm sed

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- "${REVIEWDOG_VERSION}"

RUN wget -O /formatter.js https://raw.githubusercontent.com/reviewdog/action-eslint/master/eslint-formatter-rdjson/index.js 

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
