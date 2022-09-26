# libreoffice-unoserver

The LibreOffice with unoserver on Docker

## Spec

- Base image: [adoptopenjdk/openjdk11](https://hub.docker.com/r/adoptopenjdk/openjdk11)
- Version: `jre-11.0.6_10-alpine`

## Environment Variables

| Variable      | Default   | Required | Description               |
| ------------- | --------- | -------- | ------------------------- |
| UNOSERVER_CMD | unoserver |          | Set the unoserver command |
