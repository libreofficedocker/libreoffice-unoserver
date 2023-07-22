## About

A packaged unoserver with REST APIs using Libreoffice in Docker

### Pre-built image

[![Release](https://github.com/libreofficedocker/libreoffice-unoserver/actions/workflows/release.yml/badge.svg)](https://github.com/libreofficedocker/libreoffice-unoserver/actions/workflows/release.yml)
[![Test](https://github.com/libreofficedocker/libreoffice-unoserver/actions/workflows/test.yml/badge.svg)](https://github.com/libreofficedocker/libreoffice-unoserver/actions/workflows/test.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/libreofficedocker/libreoffice-unoserver)](https://hub.docker.com/r/libreofficedocker/libreoffice-unoserver)

This image uses the [`alpine`](https://hub.docker.com/_/alpine) as base images.

> **Note**
>
> You can find the pre-built images on [Docker Hub](https://hub.docker.com/u/libreofficedocker).
> All release are built following Alpine release versions and only the last 10 versions are built.

```
docker pull libreofficedocker/libreoffice-unoserver:${ALPINE_VERSION}
```

### REST API

This image shipped with REST API for unoserver by default.

See https://github.com/libreofficedocker/unoserver-rest-api for more information.

> **Warning**
>
> It is important to know that the REST API layer DOES NOT provide any type of security whatsoever.
> It is NOT RECOMMENDED to expose this container image to the internet.

## Releases

The following releases are available:

- `edge`
- `3.18`
- `3.17`
- `3.16`
- `3.15`
- `3.14`
- `3.13`
- `3.12`
- `3.11`
- `3.10`

## Limitations

> ⚠️⚠️ Please DO NOT expose the container to the internet ⚠️⚠️

It is important to know that the REST API layer DOES NOT provide any type of security whatsoever.

The service can process only one document at a time. There is no form of load balancing built into the `unoserver` nor **REST API**.

## License

Licensed under [Apache-2.0 license](LICENSE)
