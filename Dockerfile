FROM        alpine:3.21.0

LABEL       org.opencontainers.image.source="https://github.com/dandenkijin/docker-weechat"

LABEL       maintainer="dandenkijin"

WORKDIR     /config

ENV         TERM=xterm-256color \
            LANG=C.UTF-8
            S6_OVERLAY_VERSION=v3.2.0.2 \
            GO_DNSMASQ_VERSION=1.0.7

COPY        root /


RUN         set -x; \
            chmod +x /init && \
            echo "**** install packages ****" && \
            apk add --no-cache bind-tools curl libcap && \
            curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
            | tar xfz - -C / && \
            curl -sSL https://github.com/janeczku/go-dnsmasq/releases/download/${GO_DNSMASQ_VERSION}/go-dnsmasq-min_linux-amd64 -o /bin/go-dnsmasq && \
            chmod +x /bin/go-dnsmasq && \
            apk del curl && \
            # create user and give binary permissions to bind to lower port
            addgroup go-dnsmasq && \
            adduser -D -g "" -s /bin/sh -G go-dnsmasq go-dnsmasq && \
            setcap CAP_NET_BIND_SERVICE=+eip /bin/go-dnsmasq \
            aspell-libs \
            curl \
            dumb-init \
            gettext \
            gnutls \
            libgcrypt \
            ncurses \
            python3 \ 
            ruby \
            shadow \
            su-exec \
            tzdata \
            weechat && \
            echo "**** cleanup ****" && \
            rm -rf /tmp/* /var/cache/apk/*

VOLUME      /config /downloads

ENTRYPOINT  [ "/init"]
CMD         [ ]
