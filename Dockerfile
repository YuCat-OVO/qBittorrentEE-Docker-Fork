FROM alpine:edge AS build

ARG QBEE_TAG
ARG FILE_NAME

COPY root /default

RUN apk --no-cache add bash wget curl unzip zip jq

RUN \
    curl -L -o "/tmp/qbittorrentee.zip" "https://github.com/YuCat-OVO/qBittorrent-Enhanced-Edition/releases/download/release-${QBEE_TAG}/${FILE_NAME}" && \
    unzip "/tmp/qbittorrentee.zip" && \
    mkdir -p /default/usr/bin && \
    mv /tmp/qbittorrent-nox /default/usr/bin &&\
    chmod 755 /default/usr/bin/qbittorrent-nox


FROM alpine:20240329

COPY --from=build /default /

ENV QBT_PROFILE=/home/qbittorrent \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=100 \
    WEBUI_PORT=8080 \
    BT_PORT=34567 \
    QB_USERNAME=admin \
    QB_PASSWORD=adminadmin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ "

RUN \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' /etc/apk/repositories && \
    apk add --no-cache \
    bash \
    busybox-suid \
    curl \
    jq \
    openssl \
    python3 \
    shadow \
    su-exec \
    tini \
    tzdata && \
    useradd -l qbittorrent -u ${PUID} -U -m -d ${QBT_PROFILE} -s /sbin/nologin

WORKDIR /data
VOLUME ["/data"]
ENTRYPOINT ["tini", "-g", "--", "entrypoint.sh"]
