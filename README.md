## About

The LibreOffice with unoserver on Docker

### Pre-built image

[![Docker Pulls](https://img.shields.io/docker/pulls/libreofficedocker/libreoffice-unoserver)](https://hub.docker.com/r/libreofficedocker/libreoffice-unoserver)

This image uses the [`alpine`](https://hub.docker.com/_/alpine) as base images.

> **Note**
>
> You can find the pre-built images on [Docker Hub](https://hub.docker.com/u/libreofficedocker).  
> All release are built following Alpine release versions and only the last 5 versions are built.

```
docker pull libreofficedocker/libreoffice-unoserver:${ALPINE_VERSION}
```

### REST API

This image shipped with REST API for unoserver by default.

See https://github.com/libreoffice-docker/unoserver-rest-api for more information.

## License

Licensed under [Apache-2.0 license](LICENSE)
