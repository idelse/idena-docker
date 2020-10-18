# build stage
FROM            golang:alpine AS builder
LABEL           autodelete="true"
ARG             REPO=idenadev
ARG             IDENA_REPO=idena-network/idena-go
ARG             BUILD_TARGET=idena
ARG             BUILD_COMMIT=b251f609d9e7375a0b7e00f63ea2fa1754ce7240
RUN             apk add git gcc libc-dev
RUN             git clone https://github.com/${IDENA_REPO} /idena
WORKDIR         /idena
RUN             git reset --hard ${BUILD_COMMIT}
RUN             go build -o ${BUILD_TARGET}
RUN             strip ${BUILD_TARGET}

# final stage
FROM            alpine:latest
ARG             BUILD_TARGET=idena
ARG             USER=idena
ENV             BUILD_TARGET=${BUILD_TARGET}
RUN             apk add --update nodejs npm
RUN             npm install -i pm2
COPY            ./proxy /proxy
RUN             cd /proxy && npm install
RUN             apk --no-cache add ca-certificates 'su-exec>=0.2' \
                && addgroup $USER -g 500 \
			    && adduser -u 500 -D -h /home/$USER -S -s /sbin/nologin -G $USER $USER
COPY            --from=builder ${BUILD_TARGET} /usr/local/bin
COPY            docker-entrypoint.sh /usr/local/bin/
COPY            config.json /home/$USER/
RUN             chmod +x /usr/local/bin/${BUILD_TARGET}
WORKDIR         /home/$USER
EXPOSE          80
ENTRYPOINT      ["docker-entrypoint.sh"]
CMD             ["", "run"]