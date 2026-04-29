#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/build.sh"

docker --version
docker buildx version

function alpine()
{
    local image_registry="index.docker.io/cyayung804"
    local image_name="alpine"

    echo "  -> Initializing ${FUNCNAME}..."

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"

    cd "src/${image_name}" || return

    latest_version="$(cat .alpine-version)"
    export IMAGE_TAG="${latest_version}"
    export ALPINE_VERSION="${latest_version}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
    else
        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    fi
}

"$@"
