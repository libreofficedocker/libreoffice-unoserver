variable "ALPINE_VERSION" {
    default = "3.16"
}
variable "S6_OVERLAY_VERSION" {
    default = "v3.1.5.0"
}
variable "UNOSERVER_REST_API_VERSION" {
    default = "v0.6.2"
}

target "docker-metadata-action" {}

target "default" {
    inherits = ["docker-metadata-action"]
    dockerfile = "Dockerfile"
    context = "."
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        S6_OVERLAY_VERSION = "${S6_OVERLAY_VERSION}"
    }
}
