#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/update.sh"

function alpine()
{
    local image_registry="public.ecr.aws/docker/library"
    local image_name="alpine"
    local regex_minor_version='^[0-9]+\.[0-9]+$'
    latest_minor_version="$(crane ls "${image_registry}/${image_name}" | grep -E "${regex_minor_version}" | sort -Vr | head -n 1)"
    latest_versions="$(crane ls "${image_registry}/${image_name}" | grep -E "${regex_minor_version}" | sort -Vr)"

    if [[ -z "$latest_minor_version" ]]; then
        echo "  [!] Error: Could not retrieve version for ${image_name}"
        return 1
    fi

    echo "  -> Initializing ${FUNCNAME}..."

    mkdir -p "src/${image_name}"
    cd "src/${image_name}" || return

    echo "Updating latest ${image_name} version..."
    echo "${latest_minor_version}" > .alpine-version

    cat .alpine-version

    echo "Exporting all other ${image_name}" versions...
    echo "$(echo "${latest_versions}" | tail -n +2)" > .alpine-versions.txt

    cat .alpine-versions.txt
}

function all()
{
    echo "  -> Initializing ${FUNCNAME}..."
    alpine
}

${1:-all} "${@:2}"
