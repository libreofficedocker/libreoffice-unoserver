# libreoffice-unoserver

[![Docker Pulls](https://img.shields.io/docker/pulls/libreofficedocker/libreoffice-unoserver)](https://hub.docker.com/r/libreofficedocker/libreoffice-unoserver)

The LibreOffice with unoserver on Docker

## About

This uses the [`alpine:3.16`](https://hub.docker.com/_/alpine) as base images.

**NOTE**: Please fork or create a new project from this template to build your own image.

### Pre-built image

> **Warning**
>
> We do not provide stable pre-built images, but we have an unstable `nightly` image for testing.
>
> The `nightly` image may not up-to-date.

```
libreofficedocker/libreoffice-unoserver:nightly
```

### REST API

This image does not shipped with REST API for unoserver by default.

Please use https://github.com/libreoffice-docker/unoserver-rest-api.

### Environment Variables

| Variable      | Default   | Required | Description               |
| ------------- | --------- | -------- | ------------------------- |
| UNOSERVER_CMD | unoserver |          | Set the unoserver command |

## License

Licensed under [Apache-2.0 license](LICENSE)
