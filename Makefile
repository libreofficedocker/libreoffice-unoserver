DOCKER_REGISTRY=libreofficedocker
DOCKER_NAME=libreoffice-unoserver
DOCKER_TAG=3.16
DOCKER_IMAGE=${DOCKER_REGISTRY}/${DOCKER_NAME}:${DOCKER_TAG}

build:
	docker buildx bake

push:
	docker push ${DOCKER_IMAGE}

run:
	docker run -it --rm ${DOCKER_IMAGE}

shell:
	docker run -it --rm ${DOCKER_IMAGE} sh
