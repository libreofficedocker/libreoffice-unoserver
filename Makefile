DOCKER_REGISTRY=socheatsok78
DOCKER_NAME=libreoffice-unoserver
DOCKER_TAG=nightly
DOCKER_IMAGE=${DOCKER_REGISTRY}/${DOCKER_NAME}:${DOCKER_TAG}

build:
	docker build --pull --rm -f "Dockerfile" -t ${DOCKER_IMAGE} "."

push:
	docker push ${DOCKER_IMAGE}

run:
	docker run -it --rm  -p "2004:2003" \
		${DOCKER_IMAGE}

shell:
	docker run -it --rm -p "2004:2003" \
		${DOCKER_IMAGE} sh
