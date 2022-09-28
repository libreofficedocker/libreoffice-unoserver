DOCKER_REGISTRY=libreofficedocker
DOCKER_NAME=libreoffice-unoserver-alpine
DOCKER_TAG=nightly
DOCKER_IMAGE=${DOCKER_REGISTRY}/${DOCKER_NAME}:${DOCKER_TAG}

build:
	docker build --pull --rm -f "Dockerfile" -t ${DOCKER_IMAGE} "."

push:
	docker push ${DOCKER_IMAGE}

run:
	docker run -it --rm ${DOCKER_IMAGE}

shell:
	docker run -it --rm ${DOCKER_IMAGE} sh
