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

    latest_alpine_version="$(cat .alpine-version)"
    export ALPINE_VERSION="${latest_alpine_version}"
    export IMAGE_TAG="${latest_alpine_version}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
    else
        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    fi
}

function golang()
{
    local image_registry="index.docker.io/cyayung804"
    local image_name="golang"

    echo "  -> Initializing ${FUNCNAME}..."

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"

    cd "src/${image_name}" || return

    latest_alpine_version="$(cat .alpine-version)"
    latest_go_version="$(cat .go-version)"
    export ALPINE_VERSION="${latest_alpine_version}"
    export GO_VERSION="${latest_go_version}"
    export IMAGE_TAG="${latest_go_version}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
    else
        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    fi
}

function terraform()
{
    local image_registry="index.docker.io/cyayung804"
    local image_name="terraform"

    echo "  -> Initializing ${FUNCNAME}..."

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"

    cd "src/${image_name}" || return

    latest_alpine_version="$(cat .alpine-version)"
    latest_tf_version="$(cat .tf-version)"
    export ALPINE_VERSION="${latest_alpine_version}"
    export TF_VERSION="${latest_tf_version}"
    export IMAGE_TAG="${latest_tf_version}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
    else
        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    fi
}

"$@"
