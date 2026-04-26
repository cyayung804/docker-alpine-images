#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/build_all.sh"

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

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_repo}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${image_repo}:${IMAGE_TAG} already exists."
        continue
    fi

    echo "Building ${image_uri}..."
    docker buildx bake push
}

function all()
{
    echo "  -> Initializing ${FUNCNAME}..."
    alpine
}

${1:-all} "${@:2}"
