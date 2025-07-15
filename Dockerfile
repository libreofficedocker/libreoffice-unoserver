ARG ALPINE_VERSION
ARG S6_VERSION=v3.2.1.0

FROM socheatsok78/s6-overlay:${S6_VERSION} AS s6-overlay
FROM socheatsok78/s6-overlay:${S6_VERSION}-symlinks AS s6-overlay-symlinks

FROM libreofficedocker/alpine:${ALPINE_VERSION}

# socheatsok78/s6-overlay
COPY --link --from=s6-overlay / /
COPY --link --from=s6-overlay-symlinks / /

RUN --mount=type=bind,target=/tmp/buildfs,source=buildfs \
<<EOT
    cd /tmp/buildfs
    ./install-unoserver.sh
EOT

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
