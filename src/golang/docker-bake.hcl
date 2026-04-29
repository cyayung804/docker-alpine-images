group "default" {
  targets = ["push"]
}

target "metadata" {
  labels = {
    "org.opencontainers.image.authors"            = "${GITHUB_REPOSITORY_OWNER}"
    "org.opencontainers.image.os.name"            = "alpine"
    "org.opencontainers.image.os.version"         = "${ALPINE_VERSION}"
    "org.opencontainers.image.ref.name"           = "${GITHUB_REF_NAME}"
    "org.opencontainers.image.revision"           = "${GITHUB_SHA}"
    "org.opencontainers.image.runtime.go.version" = "${GO_VERSION}"
    "org.opencontainers.image.source"             = "${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}"
    "org.opencontainers.image.title"              = "${IMAGE_NAME}"
    "org.opencontainers.image.url"                = "${IMAGE_REGISTRY}/${IMAGE_NAME}"
    "org.opencontainers.image.version"            = "${IMAGE_TAG}"
  }
}

target "push" {
  inherits  = ["settings", "metadata"]
  output    = ["type=registry"]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = [
    "${IMAGE_REGISTRY}/${IMAGE_NAME}:latest",
    "${IMAGE_REGISTRY}/${IMAGE_NAME}:${GO_VERSION}",
    "${IMAGE_REGISTRY}/${IMAGE_NAME}:${GO_VERSION}-alpine${ALPINE_VERSION}",
  ]
}

target "settings" {
  args = {
    alpine_version = "${ALPINE_VERSION}"
    go_version     = "${GO_VERSION}"
  }
  context    = "."
  dockerfile = "Dockerfile"
}

variable "ALPINE_VERSION" {}

variable "GO_VERSION" {}

variable "GITHUB_REF_NAME" {}

variable "GITHUB_REPOSITORY" {}

variable "GITHUB_REPOSITORY_OWNER" {}

variable "GITHUB_SERVER_URL" {}

variable "GITHUB_SHA" {}

variable "IMAGE_NAME" {}

variable "IMAGE_REGISTRY" {}

variable "IMAGE_TAG" {}
