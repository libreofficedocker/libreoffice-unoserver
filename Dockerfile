ARG ALPINE_VERSION
FROM libreofficedocker/alpine:${ALPINE_VERSION}

RUN --mount=type=bind,target=/tmp/buildfs,source=buildfs \
<<EOT
    cd /tmp/buildfs
    ./install-unoserver.sh
EOT

# https://github.com/socheatsok78/s6-overlay-installer
ARG S6_OVERLAY_VERSION=v3.1.5.0
ARG S6_OVERLAY_INSTALLER=main/s6-overlay-installer.sh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/socheatsok78/s6-overlay-installer/${S6_OVERLAY_INSTALLER})"

# unoserver-rest-api
ARG TARGETOS
ARG TARGETARCH
ARG UNOSERVER_REST_API_VERSION
ARG UNOSERVER_REST_API_RELEASE_URL=https://github.com/libreofficedocker/unoserver-rest-api/releases/download/${UNOSERVER_REST_API_VERSION}
ADD ${UNOSERVER_REST_API_RELEASE_URL}/unoserver-rest-api-${TARGETOS}-${TARGETARCH} /usr/bin/unoserver-rest-api
RUN chmod +x /usr/bin/unoserver-rest-api
EXPOSE 2004

# RootFS
ADD rootfs /
ENTRYPOINT ["/init-shim"]
CMD [ "/docker-cmd.sh" ]
