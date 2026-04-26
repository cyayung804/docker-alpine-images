#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/build.sh"

function alpine()
{
    local image_registry="docker.io/cyayung804"
    local image_name="alpine"

    echo "  -> Initializing ${FUNCNAME}..."

    cd "src/${image_name}" || return

    docker --version
    docker buildx version

    latest_version="$(cat .alpine-version)"
    export IMAGE_TAG="${latest_version}"
    export ALPINE_VERSION="${latest_version}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
        continue
    fi

    echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
    docker buildx bake push
}

function all()
{
    echo "  -> Initializing ${FUNCNAME}..."
    alpine
}

${1:-all} "${@:2}"
