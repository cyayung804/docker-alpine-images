#!/bin/bash

set -e

echo "==> Running $(dirname "$(realpath "$0")")/update.sh"

regex_minor_version='^[0-9]+\.[0-9]+$'
regex_major_version='^[0-9]+\.[0-9]+\.[0-9]+$'

function alpine()
{
    local image_registry="public.ecr.aws/docker/library"
    local image_name="alpine"
    local count=0
    echo "  -> Initializing ${FUNCNAME}..."

    until latest_versions="$(crane ls "${image_registry}/${image_name}" | grep -E "${regex_minor_version}" | head -n 50 | sort -Vr)" || [ $count -eq 5 ]; do
        count=$((count + 1))
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

    until latest_versions="$(crane ls "${image_registry}/${image_name}" | grep -E "${regex_major_version}" | head -n 50 | sort -Vr)" || [ $count -eq 5 ]; do
        count=$((count + 1))
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

function run()
{
    local target="$1"

    cd "src/${target}" || exit 1

    case "$target" in
        alpine)
            alpine
            ;;
        golang)
            alpine
            golang
            ;;
        *)
            echo "Unknown target: $target"
            exit 1
            ;;
    esac
}

run "$1"
