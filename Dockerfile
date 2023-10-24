ARG ALPINE_VERSION
FROM libreofficedocker/alpine:${ALPINE_VERSION}

# Install PIP and unoserver
ARG ALPINE_VERSION
RUN <<EOF
    set -euxo pipefail
    export PYTHONUNBUFFERED=1
    if [ ! -f /usr/bin/python ]; then
        ln -s /usr/bin/python3 /usr/bin/python
    fi
    if [ ${ALPINE_VERSION} = "edge" ]; then
        pip3 install --break-system-packages --no-cache unoserver==1.6
    else
        pip3 install --no-cache unoserver==1.6
    fi
EOF

# https://github.com/socheatsok78/s6-overlay-installer
ARG S6_OVERLAY_VERSION=v3.1.5.0
ARG S6_OVERLAY_INSTALLER=main/s6-overlay-installer.sh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/socheatsok78/s6-overlay-installer/${S6_OVERLAY_INSTALLER})"
ARG S6_VERBOSITY=1 \
    S6_KEEP_ENV=0 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_VERBOSITY=${S6_VERBOSITY} \
    S6_KEEP_ENV=${S6_KEEP_ENV} \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=${S6_BEHAVIOUR_IF_STAGE2_FAILS}
ENTRYPOINT ["/init"]

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
CMD [ "/docker-cmd.sh" ]
