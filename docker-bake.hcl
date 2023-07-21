variable "ALPINE_VERSION" {
    default = "3.16"
}
variable "S6_OVERLAY_VERSION" {
    default = "v3.1.5.0"
}
variable "UNOSERVER_REST_API_VERSION" {
    default = "v0.8.0"
}

target "docker-metadata-action" {}

target "default" {
    inherits = ["docker-metadata-action"]
    dockerfile = "Dockerfile"
    context = "."
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        S6_OVERLAY_VERSION = "${S6_OVERLAY_VERSION}"
        UNOSERVER_REST_API_VERSION = "${UNOSERVER_REST_API_VERSION}"
    }
    platforms = [
        "linux/amd64",
        "linux/arm64",
    ]
}
