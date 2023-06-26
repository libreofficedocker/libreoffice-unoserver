variable "DOCKER_IMAGE_NAME" {
    default = "libreofficedocker/libreoffice-unoserver"
}

variable "ALPINE_VERSION" {
    default = "3.16"
}

variable "S6_OVERLAY_VERSION" {
    default = "v3.1.5.0"
}

target "default" {
    dockerfile = "Dockerfile"
    context = "."
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        S6_OVERLAY_VERSION = "${S6_OVERLAY_VERSION}"
    }
    tags = ["${DOCKER_IMAGE_NAME}:${ALPINE_VERSION}"]
}
