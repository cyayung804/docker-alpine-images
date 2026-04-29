#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/update.sh"

regex_major_semver='^(0|[1-9][0-9]*)$'
regex_minor_semver='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
regex_patch_semver='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'

function alpine()
{
    local image_registry="public.ecr.aws/docker/library"
    local image_name="alpine"
    local count=0
    echo "  -> Initializing ${FUNCNAME}..."

    until latest_versions=$(crane ls "${image_registry}/${image_name}" 2>/dev/null | grep -E "${regex_minor_semver}" | head -n 25 | sort -Vr) && [ -n "$latest_versions" ] || [ $count -eq 5 ]; do
        count=$((count + 1))
        echo "     Rate limited or empty response. Retrying ($count/5)..."
        sleep 5
    done
    latest_version="$(echo "${latest_versions}" | head -n 1)"

    echo "Updating latest ${image_name} version..."
    echo "${latest_version}" > .alpine-version
    cat .alpine-version

    echo "Exporting all other ${image_name} versions..."
    echo "$(echo "${latest_versions}" | tail -n +2)" > .alpine-versions.txt
    cat .alpine-versions.txt
}

function golang()
{
    local image_registry="public.ecr.aws/docker/library"
    local image_name="golang"
    local count=0
    echo "  -> Initializing ${FUNCNAME}..."

    until latest_versions=$(crane ls "${image_registry}/${image_name}" 2>/dev/null | grep -E "${regex_patch_semver}" | head -n 25 | sort -Vr) && [ -n "$latest_versions" ] || [ $count -eq 5 ]; do
        count=$((count + 1))
        echo "     Rate limited or empty response. Retrying ($count/5)..."
        sleep 5
    done
    latest_version="$(echo "${latest_versions}" | head -n 1)"

    echo "Updating latest ${image_name} version..."
    echo "${latest_version}" > .go-version
    cat .go-version

    echo "Exporting all other ${image_name} versions..."
    echo "$(echo "${latest_versions}" | tail -n +2)" > .go-versions.txt
    cat .go-versions.txt
}

function node()
{
    local image_registry="public.ecr.aws/docker/library"
    local image_name="node"
    local count=0
    echo "  -> Initializing ${FUNCNAME}..."

    until latest_versions=$(crane ls "${image_registry}/${image_name}" 2>/dev/null | grep -E "${regex_patch_semver}" | head -n 25 | sort -Vr) && [ -n "$latest_versions" ] || [ $count -eq 5 ]; do
        count=$((count + 1))
        echo "     Rate limited or empty response. Retrying ($count/5)..."
        sleep 5
    done
    latest_version="$(echo "${latest_versions}" | head -n 1)"

    echo "Updating latest ${image_name} version..."
    echo "${latest_version}" > .node-version
    cat .node-version

    echo "Exporting all other ${image_name} versions..."
    echo "$(echo "${latest_versions}" | tail -n +2)" > .node-versions.txt
    cat .node-versions.txt
}

function python()
{
    local image_registry="public.ecr.aws/docker/library"
    local image_name="python"
    local count=0
    echo "  -> Initializing ${FUNCNAME}..."

    until latest_versions=$(crane ls "${image_registry}/${image_name}" 2>/dev/null | grep -E "${regex_patch_semver}" | head -n 25 | sort -Vr) && [ -n "$latest_versions" ] || [ $count -eq 5 ]; do
        count=$((count + 1))
        echo "     Rate limited or empty response. Retrying ($count/5)..."
        sleep 5
    done
    latest_version="$(echo "${latest_versions}" | head -n 1)"

    echo "Updating latest ${image_name} version..."
    echo "${latest_version}" > .python-version
    cat .python-version

    echo "Exporting all other ${image_name} versions..."
    echo "$(echo "${latest_versions}" | tail -n +2)" > .python-versions.txt
    cat .python-versions.txt
}

function terraform()
{
    local count=0
    echo "  -> Initializing ${FUNCNAME}..."

    touch .terraform-version
    cat .terraform-version
    touch .terraform-versions.txt
    cat .terraform-versions.txt
}

function run()
{
    local target="$1"

    echo "==> Updating ${target}..."
    cd "src/${target}" || exit 1

    case "$target" in
        alpine)
            alpine
            ;;
        golang)
            golang
            alpine
            ;;
        node)
            node
            alpine
            ;;
        python)
            python
            alpine
            ;;
        terraform)
            terraform
            alpine
            ;;
        *)
            echo "Unknown target: $target"
            exit 1
            ;;
    esac
}

run "$1"
