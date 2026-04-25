#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/build_all.sh"

docker --version
docker buildx version
date="$(date -Iseconds)"

function alpine()
{
    local image_registry="index.docker.io/cyayung804"
    local image_name="alpine"

    cd "src/${image_name}" || return

    latest_versions="$(cat .alpine-versions.txt | sort -V)"

    while read -r IMAGE_TAG; do
        if crane ls "${image_registry}/${image_name}" | grep -Fxq "${IMAGE_TAG}"; then
            echo "${image_registry}/${image_name}:${IMAGE_TAG} already exists..."
            continue
        fi

        export IMAGE_REGISTRY="${image_registry}"
        export IMAGE_NAME="${image_name}"
        export IMAGE_TAG="${IMAGE_TAG}"
        export ALPINE_VERSION="${IMAGE_TAG}"
        export DATE="${date}"

        echo "Building ${image_registry}/${image_name}:${IMAGE_TAG}..."
        docker buildx bake push
    done < <(echo "${latest_versions}")
}

function golang()
{
    local image_registry="index.docker.io/cyayung804"
    local image_name="golang"

    cd "src/${image_name}" || return

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"
    export DATE="${date}"

    local alpine_versions
    local latest_versions

    alpine_versions="$(sort -V .alpine-versions.txt)"
    latest_versions="$(head -n +57 .go-versions.txt | sort -V)" # index head -n +57 rebuild

    for alpine_version in ${alpine_versions}; do
        export ALPINE_VERSION="${alpine_version}"

        echo "${latest_versions}" | xargs -r -n 1 -P 4 bash -c '
            go_version="$1"
            image_tag="${go_version}-alpine${ALPINE_VERSION}"

            if crane ls "${IMAGE_REGISTRY}/${IMAGE_NAME}" | grep -Fxq "${image_tag}"; then
                echo "${IMAGE_REGISTRY}/${IMAGE_NAME}:${image_tag} already exists..."
                exit 0
            fi

            export GO_VERSION="${go_version}"
            export IMAGE_TAG="${go_version}"

            docker buildx bake push
        ' _
    done
}

function terraform()
{
    local image_registry="index.docker.io/cyayung804"
    local image_name="terraform"

    cd "src/${image_name}" || return

    export IMAGE_REGISTRY="${image_registry}"
    export IMAGE_NAME="${image_name}"
    export DATE="${date}"

    local alpine_versions
    local latest_versions

    alpine_versions="$(sort -V .alpine-versions.txt)"
    latest_versions="$(head -n +137 .tf-versions.txt | sort -V)" # index head -n +137 rebuild

    for alpine_version in ${alpine_versions}; do
        export ALPINE_VERSION="${alpine_version}"

        echo "${latest_versions}" | xargs -r -n 1 -P 4 bash -c '
            tf_version="$1"
            image_tag="${tf_version}-alpine${ALPINE_VERSION}"

            if crane ls "${IMAGE_REGISTRY}/${IMAGE_NAME}" | grep -Fxq "${image_tag}"; then
                echo "${IMAGE_REGISTRY}/${IMAGE_NAME}:${image_tag} already exists..."
                exit 0
            fi

            export TF_VERSION="${tf_version}"
            export IMAGE_TAG="${tf_version}"

            docker buildx bake push
        ' _
    done
}

"$@"
