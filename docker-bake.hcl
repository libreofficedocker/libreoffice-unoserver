variable "ALPINE_VERSION" {
    default = "3.16"
}
variable "S6_OVERLAY_VERSION" {
    default = "v3.1.5.0"
}
variable "UNOSERVER_REST_API_VERSION" {
    default = "v0.6.2"
}

variable "DOCKER_META_IMAGES" {}
variable "DOCKER_META_VERSION" {}

target "default" {
    dockerfile = "Dockerfile"
    context = "."
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        S6_OVERLAY_VERSION = "${S6_OVERLAY_VERSION}"
    }
    tags = [
        "${DOCKER_META_IMAGES}:${DOCKER_META_VERSION}"
    ]
}
