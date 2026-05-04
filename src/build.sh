#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/build.sh"

docker --version
docker buildx version
date="$(date -Iseconds)"

function alpine()
{
    local image_registry="index.docker.io/cyayung804"
    local image_name="alpine"

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"

    cd "src/${image_name}" || return

    latest_alpine_version="$(cat .alpine-version)"

    export IMAGE_TAG="${latest_alpine_version}"
    export ALPINE_VERSION="${latest_alpine_version}"
    export DATE="${date}"

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

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"

    cd "src/${image_name}" || return

    latest_alpine_version="$(cat .alpine-version)"
    latest_go_version="$(cat .go-version)"

    export IMAGE_TAG="${latest_go_version}"
    export ALPINE_VERSION="${latest_alpine_version}"
    export GO_VERSION="${latest_go_version}"
    export DATE="${date}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
    else
        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    fi
}

function python()
{
    local image_registry="index.docker.io/cyayung804"
    local image_name="python"

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"

    cd "src/${image_name}" || return

    latest_alpine_version="$(cat .alpine-version)"
    latest_python_version="$(cat .python-version)"

    trap 'rm -rf src/**' EXIT INT TERM

    export IMAGE_TAG="${latest_python_version}"
    export ALPINE_VERSION="${latest_alpine_version}"
    export PYTHON_VERSION="${latest_python_version}"
    export DATE="${date}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
    else
        mkdir -p "src/${latest_alpine_version}/${latest_python_version}"
        echo "Downloading Python ${latest_python_version}-alpine${latest_alpine_version}..."
        curl -fsSL "https://www.python.org/ftp/python/${latest_python_version}/Python-${latest_python_version}.tgz" \
            -o "src/${latest_alpine_version}/${latest_python_version}/Python-${latest_python_version}.tgz"
        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    fi
}

function terraform()
{
    local image_registry="index.docker.io/cyayung804"
    local image_name="terraform"

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"

    cd "src/${image_name}" || return

    latest_alpine_version="$(cat .alpine-version)"
    latest_tf_version="$(cat .tf-version)"

    export IMAGE_TAG="${latest_tf_version}"
    export ALPINE_VERSION="${latest_alpine_version}"
    export TF_VERSION="${latest_tf_version}"
    export DATE="${date}"

    if [[ "${IMAGE_TAG}" != "latest" ]] && crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
        echo "  [~] Skipping: ${IMAGE_TAG} already exists."
    else
        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    fi
}

"$@"
