ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

ARG ALPINE_VERSION
RUN <<EOF
    set -euxo pipefail
    ICU_PKGS=""
    if [ ${ALPINE_VERSION} = "edge" ]; then
        ICU_PKGS="icu-data-full"
    elif [ "$(echo "${ALPINE_VERSION} < 3.13" | bc)" -eq 1 ]; then
        ICU_PKGS=""
    elif [ "$(echo "${ALPINE_VERSION} < 3.16" | bc)" -eq 1 ]; then
        ICU_PKGS="icu-data"
    else
        ICU_PKGS="icu-data-full"
    fi
    ALPING_EXTRA_PKGS=""
    if [ "$(echo "${ALPINE_VERSION} >= 3.13" | bc)" -eq 1 ]; then
        ALPING_EXTRA_PKGS="font-noto-all"
    fi
    apk add -U --no-cache \
        bash curl tzdata \
        icu icu-libs ${ICU_PKGS} \
        fontconfig freetype freetype-dev \
        ttf-dejavu msttcorefonts-installer \
        libstdc++ dbus-x11 \
        ${ALPING_EXTRA_PKGS}
    update-ms-fonts
    fc-cache -fv
EOF

# Install LibreOffice
RUN <<EOF
    set -euxo pipefail
    apk add -U --no-cache \
        libreoffice-common \
        libreoffice-calc \
        libreoffice-draw \
        libreoffice-impress \
        libreoffice-writer \
        libreoffice-lang-en_us \
        libreofficekit \
        openjdk11-jre-headless
EOF

# Install PIP and unoserver
RUN <<EOF
    set -euxo pipefail
    export PYTHONUNBUFFERED=1
    if [ ! -f /usr/bin/python ]; then
        ln -s /usr/bin/python3 /usr/bin/python
    fi
    python3 -m ensurepip
    pip3 install --no-cache unoserver
EOF

ENV LD_LIBRARY_PATH=/usr/lib
ENV URE_BOOTSTRAP="vnd.sun.star.pathname:/usr/lib/libreoffice/program/fundamentalrc"
ENV PATH="/usr/lib/libreoffice/program:$PATH"
ENV UNO_PATH="/usr/lib/libreoffice/program"
ENV LD_LIBRARY_PATH="/usr/lib/libreoffice/program:/usr/lib/libreoffice/ure/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH="/usr/lib/libreoffice/program:$PYTHONPATH"

# https://github.com/socheatsok78/s6-overlay-installer
ARG S6_OVERLAY_VERSION=v3.1.5.0
ARG S6_OVERLAY_INSTALLER=main/s6-overlay-installer-minimal.sh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/socheatsok78/s6-overlay-installer/${S6_OVERLAY_INSTALLER})"
ARG S6_VERBOSITY=2 \
    S6_KEEP_ENV=0 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=0
ENV S6_VERBOSITY=${S6_VERBOSITY} \
    S6_KEEP_ENV=${S6_KEEP_ENV} \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=${S6_BEHAVIOUR_IF_STAGE2_FAILS}
ENTRYPOINT ["/init"]

# Uncomment the following line to enable REST API for unoserver
ARG UNOSERVER_REST_API_VERSION
RUN <<EOF
    set -euxo pipefail
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
CMD [ "/docker-cmd.sh" ]
