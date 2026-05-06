#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/build.sh"

date="$(date -Iseconds)"
docker --version
docker buildx version

function alpine()
{
    local image_name="alpine"
    local image_registry="index.docker.io/cyayung804"

    export DATE="${date}"
    export IMAGE_NAME="${image_name}"
    export IMAGE_REGISTRY="${image_registry}"

    cd "src/${image_name}" || return

    export ALPINE_VERSION="$(cat .alpine-version)"
    export IMAGE_TAG="${ALPINE_VERSION}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
    else
        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    fi
}

function golang()
{
    local image_name="golang"
    local image_registry="index.docker.io/cyayung804"

    export DATE="${date}"
    export IMAGE_NAME="${image_name}"
    export IMAGE_REGISTRY="${image_registry}"

    cd "src/${image_name}" || return

    alpine_version="$(cat .alpine-version)"
    go_version="$(cat .go-version)"

    export ALPINE_VERSION="${alpine_version}"
    export GO_VERSION="${go_version}"
    export IMAGE_TAG="${GO_VERSION}"

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

    export DATE="${date}"
    export IMAGE_NAME="${image_name}"
    export IMAGE_REGISTRY="${image_registry}"

    cd "src/${image_name}" || return

    alpine_version="$(cat .alpine-version)"
    tf_version="$(cat .tf-version)"

    export ALPINE_VERSION="${alpine_version}"
    export TF_VERSION="${tf_version}"
    export IMAGE_TAG="${TF_VERSION}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
    else
        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    fi
}

"$@"
