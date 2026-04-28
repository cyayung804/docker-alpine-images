#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/build_all.sh"

docker --version
docker buildx version

function alpine()
{
    local image_registry="docker.io/cyayung804"
    local image_name="alpine"

    echo "  -> Initializing ${FUNCNAME}..."

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"

    cd "src/${image_name}" || return

    latest_versions="$(cat .alpine-versions.txt | sort -V)"
    while read -r IMAGE_TAG; do

        if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
            echo "  [~] Skipping: ${IMAGE_TAG} already exists."
            continue
        fi

        export IMAGE_TAG="${IMAGE_TAG}"
        export ALPINE_VERSION="${IMAGE_TAG}"

        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push

    done < <(echo "${latest_versions}")

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
