ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

ARG ALPINE_VERSION
RUN <<EOF
    ICU_DATA_PKG="icu-data-full"
    if [ "$(echo "${ALPINE_VERSION} < 3.16" | bc)" -eq 1 ]; then
        ICU_DATA_PKG="icu-data"
    fi
    apk add -U --no-cache \
        bash curl tzdata \
        icu icu-libs ${ICU_DATA_PKG} \
        freetype freetype-dev \
        ttf-dejavu msttcorefonts-installer \
        openjdk11-jre openjdk11-jre-headless \
        musl musl-dev musl-locales musl-locales-lang libc6-compat
    update-ms-fonts
    fc-cache -fv
EOF

# Install LibreOffice
RUN <<EOF
    apk add -U --no-cache \
        libreoffice-common \
        libreoffice-calc \
        libreoffice-draw \
        libreoffice-impress \
        libreoffice-writer \
        libreoffice-lang-en_us
EOF

# Install PIP and unoserver
RUN <<EOF
    export PYTHONUNBUFFERED=1
    ln -s /usr/bin/python3 /usr/bin/python
    python3 -m ensurepip
    pip3 install --no-cache --upgrade pip
    pip3 install --no-cache unoserver
EOF

ENV LD_LIBRARY_PATH /usr/lib \
    URE_BOOTSTRAP "vnd.sun.star.pathname:/usr/lib/libreoffice/program/fundamentalrc" \
    PATH "/usr/lib/libreoffice/program:$PATH" \
    UNO_PATH "/usr/lib/libreoffice/program" \
    LD_LIBRARY_PATH "/usr/lib/libreoffice/program:/usr/lib/libreoffice/ure/lib:$LD_LIBRARY_PATH" \
    PYTHONPATH "/usr/lib/libreoffice/program:$PYTHONPATH"

ARG S6_OVERLAY_VERSION
RUN <<EOF
    S6_ARCH=$(uname -m)
    cd /tmp
    curl -sLO https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz
    curl -sLO https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz.sha256
    curl -sLO https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz
    curl -sLO https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz.sha256
    sha256sum -c *.sha256
    tar -C / -Jxpf s6-overlay-noarch.tar.xz
    tar -C / -Jxpf s6-overlay-${S6_ARCH}.tar.xz
    rm -rf /tmp/*.tar*
EOF
ENV S6_VERBOSITY=1 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENTRYPOINT [ "/init" ]

# Uncomment the following line to enable REST API for unoserver
ARG UNOSERVER_REST_API_VERSION
RUN <<EOF
    cd /tmp
    curl -sLO https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx
    curl -sLO https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx.sha256
    sha256sum -c *.sha256
    tar -C / -Jxpf s6-overlay-module.tar.zx
    rm -rf /tmp/*.tar*
EOF
EXPOSE 2004

# RootFS
ADD rootfs /
CMD [ "rootfs/docker-cmd.sh" ]
