# libreoffice-unoserver

The LibreOffice with unoserver on Docker

## About

This uses the [`adoptopenjdk/openjdk11:jre-11.0.6_10-alpine`](https://hub.docker.com/r/adoptopenjdk/openjdk11) as base images.

**NOTE**: Please fork or create a new project from this template to build your own image.

### Pre-built image

We do not provide stable pre-built images, but we have an unstable `nightly` image for testing.

```
libreofficedocker/libreoffice-unoserver:nightly
```

### REST API

This image do not shipped with REST API for unoserver by default.

Please use https://github.com/socheatsok78/unoserver-rest-api.

### Environment Variables

| Variable      | Default   | Required | Description               |
| ------------- | --------- | -------- | ------------------------- |
| UNOSERVER_CMD | unoserver |          | Set the unoserver command |

## License

Licensed under [Apache-2.0 license](LICENSE)
