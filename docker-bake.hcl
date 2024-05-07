variable "DEFAULT_TAG" {
  default = "qbittorrentee:latest"
}

variable "TYPE" {
  default = "normal"
}

IMAGE_TYPE = equal("", TYPE) ? "normal" : "${TYPE}"

target "docker-metadata-action" {
  tags = ["${DEFAULT_TAG}"]
}
// Default target if none specified
group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits   = ["docker-metadata-action"]
  dockerfile = format("Dockerfile%s", equal("normal", IMAGE_TYPE) ? "" : ".${IMAGE_TYPE}")
}

target "image-local" {
  inherits = ["image"]
  output   = ["type=docker"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm/v7",
    "linux/arm64/v8",
  ]
}