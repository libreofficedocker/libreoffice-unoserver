FROM alpine:3.16

# Default to UTF-8 file.encoding
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        bash curl tzdata \
        freetype freetype-dev \
        icu icu-libs icu-data-full \
        musl musl-dev musl-locales musl-locales-lang libc6-compat \
    ; rm -rf /var/cache/apk/* /tmp/*


# OpenJDK JRE
ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        openjdk11-jre \
        openjdk11-jre-headless \
    ; rm -rf /var/cache/apk/* /tmp/*


# Microsoft TrueType core fonts
RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        ttf-dejavu \
        msttcorefonts-installer \
    ; rm -rf /var/cache/apk/* /tmp/* \
    ; update-ms-fonts


# LibreOffice
RUN set -xe \
    ; apk update \
    ; apk add --no-cache \
        libreoffice-common \
        libreoffice-calc \
        libreoffice-draw \
        libreoffice-impress \
        libreoffice-writer \
        libreoffice-lang-en_us \
    ; rm -rf /var/cache/apk/* /tmp/*

ENV LD_LIBRARY_PATH /usr/lib
ENV URE_BOOTSTRAP "vnd.sun.star.pathname:/usr/lib/libreoffice/program/fundamentalrc"
ENV PATH "/usr/lib/libreoffice/program:$PATH"
ENV UNO_PATH "/usr/lib/libreoffice/program"
ENV LD_LIBRARY_PATH "/usr/lib/libreoffice/program:/usr/lib/libreoffice/ure/lib:$LD_LIBRARY_PATH"
ENV PYTHONPATH "/usr/lib/libreoffice/program:$PYTHONPATH"


# Python PIP
ENV PYTHONUNBUFFERED=1
RUN python3 --version \
    ; ln -s /usr/bin/python3 /usr/bin/python \
    ; python3 -m ensurepip \
    ; pip3 install --no-cache --upgrade pip

RUN pip3 install --no-cache unoserver


# s6-overlay
ARG S6_OVERLAY_VERSION=3.1.1.2
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz.sha256 /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz.sha256 /tmp
RUN cd /tmp && sha256sum -c *.sha256 && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
    rm -rf /tmp/*.tar*
ENTRYPOINT ["/init"]


# Uncomment the following line to
# Enable REST API for unoserver
# ARG UNOSERVER_REST_API_VERSION=0.5.0
# ADD https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/v${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx /tmp
# ADD https://github.com/libreoffice-docker/unoserver-rest-api/releases/download/v${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx.sha256 /tmp
# RUN cd /tmp && sha256sum -c *.sha256 && \
#     tar -C / -Jxpf /tmp/s6-overlay-module.tar.zx && \
#     rm -rf /tmp/*.tar*
# EXPOSE 2004


# RootFS
ADD rootfs /
RUN set -xe \
    ; chmod +x /docker-cmd.sh \
    ; fc-cache -fv
CMD [ "/docker-cmd.sh" ]
