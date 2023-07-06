DOCKER_BAKE_FILE := -f Makefile.docker-bake.hcl
ALPINE_VERSION := 3.16

DOCKER_META_IMAGES := libreofficedocker/libreoffice-unoserver
DOCKER_META_VERSION := ${ALPINE_VERSION}

build:
	DOCKER_META_IMAGES=${DOCKER_META_IMAGES} DOCKER_META_VERSION=${DOCKER_META_VERSION} docker buildx bake --load $(DOCKER_BAKE_FILE)

push:
	docker push ${DOCKER_META_IMAGES}:${DOCKER_META_VERSION}

run:
	docker run -it --rm -p 2004:2004 ${DOCKER_META_IMAGES}:${DOCKER_META_VERSION}

shell:
	docker run -it --rm -p 2004:2004 ${DOCKER_META_IMAGES}:${DOCKER_META_VERSION} sh
