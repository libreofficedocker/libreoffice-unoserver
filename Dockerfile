ARG ALPINE_VERSION
FROM libreofficedocker/alpine:${ALPINE_VERSION}

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


# https://github.com/socheatsok78/s6-overlay-installer
ARG S6_OVERLAY_VERSION=v3.1.5.0
ARG S6_OVERLAY_INSTALLER=main/s6-overlay-installer-minimal.sh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/socheatsok78/s6-overlay-installer/${S6_OVERLAY_INSTALLER})"
ARG S6_VERBOSITY=2 \
    S6_KEEP_ENV=0 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_VERBOSITY=${S6_VERBOSITY} \
    S6_KEEP_ENV=${S6_KEEP_ENV} \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=${S6_BEHAVIOUR_IF_STAGE2_FAILS}
ENTRYPOINT ["/init"]

# Uncomment the following line to enable REST API for unoserver
ARG UNOSERVER_REST_API_VERSION
RUN <<EOF
    set -euxo pipefail
    cd /tmp
    curl -sLO https://github.com/libreofficedocker/unoserver-rest-api/releases/download/${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx
    curl -sLO https://github.com/libreofficedocker/unoserver-rest-api/releases/download/${UNOSERVER_REST_API_VERSION}/s6-overlay-module.tar.zx.sha256
    sha256sum -c *.sha256
    tar -C / -Jxpf s6-overlay-module.tar.zx
    rm -rf /tmp/*.tar*
EOF
EXPOSE 2004

# RootFS
ADD rootfs /
CMD [ "/docker-cmd.sh" ]
