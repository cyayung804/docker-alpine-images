#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/build_all.sh"

function alpine()
{
    local image_registry="docker.io/cyayung804"
    local image_name="alpine"

    echo "  -> Initializing ${FUNCNAME}..."

    cd "src/${image_name}" || return

    latest_versions="$(cat .alpine-versions.txt | sort -V)"

    if [[ -z "${latest_versions}" ]]; then
        echo "  [!] Error: Could not retrieve versions for ${image_name}"
        return 1
    fi

    docker --version
    docker buildx version

    while read -r IMAGE_TAG; do
        image_uri="${image_registry}/${image_name}:${IMAGE_TAG}"

        if crane manifest "$image_uri" > /dev/null 2>&1; then
            echo "  [~] Skipping: ${image_uri} already exists."
            continue
        fi

        export IMAGE_REGISTRY="${image_registry}"
        export IMAGE_NAME="${image_name}"
        export IMAGE_TAG="${IMAGE_TAG}"
        export ALPINE_VERSION="${IMAGE_TAG}"

        echo "Building ${image_uri}..."
        docker buildx bake push

    done < <(echo "${latest_versions}")
}

function all()
{
    echo "  -> Initializing ${FUNCNAME}..."
    alpine
}

${1:-all} "${@:2}"
