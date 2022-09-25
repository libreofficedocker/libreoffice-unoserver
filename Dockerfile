# FROM adoptopenjdk/openjdk11:jre-11.0.6_10-alpine
FROM eclipse-temurin:17-jre-alpine

ENV LANG en_US.UTF-8

RUN set -xe \
    ; apk update \
    ; apk add --no-cache --purge -uU \
        bash curl \
        icu-data-full icu-libs \
        zlib-dev libstdc++ dbus-x11 \
    ; rm -rf /var/cache/apk/* /tmp/*

ARG LIBREOFFICE_VERSION=
RUN set -xe \
    ; apk update \
    ; test -z "${LIBREOFFICE_VERSION}" && apk add --no-cache --purge -uU libreoffice \
    ; test -n "${LIBREOFFICE_VERSION}" && apk add --no-cache --purge -uU libreoffice==$LIBREOFFICE_VERSION \
    ; rm -rf /var/cache/apk/* /tmp/*

ENV PYTHONUNBUFFERED=1
RUN python3 --version \
    ; ln -s /usr/bin/python3 /usr/bin/python \
    ; python3 -m ensurepip \
    ; pip3 install --no-cache --upgrade pip setuptools

ENV URE_BOOTSTRAP "vnd.sun.star.pathname:/usr/lib/libreoffice/program/fundamentalrc"
ENV PATH "/usr/lib/libreoffice/program:$PATH"
ENV UNO_PATH "/usr/lib/libreoffice/program"
ENV LD_LIBRARY_PATH "/usr/lib/libreoffice/program:/usr/lib/libreoffice/ure/lib"
ENV PYTHONPATH "/usr/lib/libreoffice/program:$PYTHONPATH"
RUN pip install --no-cache unoserver

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

ADD rootfs /
RUN fc-cache -fv \
    && chmod +x /docker-cmd.sh
ONBUILD RUN fc-cache -fv
CMD [ "/docker-cmd.sh" ]
