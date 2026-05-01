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
    until latest_versions=$(crane ls "${image_registry}/${image_name}" 2>/dev/null | grep -E "${regex_minor_semver}" | sort -Vr) && [ -n "$latest_versions" ] || [ $count -eq 5 ]; do
        count=$((count + 1))
        echo "     Rate limited or empty response. Retrying ($count/5)..."
        sleep 5
    done
    echo "${latest_versions}" > .alpine-versions.txt
    cat .alpine-versions.txt | head -n 1 > .alpine-version
    echo ".alpine-version:"
    cat .alpine-version
    echo ".alpine-versions.txt:"
    cat .alpine-versions.txt
}

function golang()
{
    local image_registry="public.ecr.aws/docker/library"
    local image_name="golang"
    local count=0
    until latest_versions=$(crane ls "${image_registry}/${image_name}" 2>/dev/null | grep -E "${regex_patch_semver}" | sort -Vr) && [ -n "$latest_versions" ] || [ $count -eq 5 ]; do
        count=$((count + 1))
        echo "     Rate limited or empty response. Retrying ($count/5)..."
        sleep 5
    done
    echo "${latest_versions}" > .go-versions.txt
    cat .go-versions.txt | head -n 1 > .go-version
    echo ".go-version:"
    cat .go-version
    echo ".go-versions.txt:"
    cat .go-versions.txt
}

function node()
{
    local image_registry="public.ecr.aws/docker/library"
    local image_name="node"
    local count=0
    until latest_versions=$(crane ls "${image_registry}/${image_name}" 2>/dev/null | grep -E "${regex_patch_semver}" | sort -Vr) && [ -n "$latest_versions" ] || [ $count -eq 5 ]; do
        count=$((count + 1))
        echo "     Rate limited or empty response. Retrying ($count/5)..."
        sleep 5
    done
    echo "${latest_versions}" > .node-versions.txt
    cat .node-versions.txt | head -n 1 > .node-version
    echo ".node-version:"
    cat .node-version
    echo ".node-versions.txt:"
    cat .node-versions.txt
}

function python()
{
    local image_registry="public.ecr.aws/docker/library"
    local image_name="python"
    local count=0
    until latest_versions=$(crane ls "${image_registry}/${image_name}" 2>/dev/null | grep -E "${regex_patch_semver}" | sort -Vr) && [ -n "$latest_versions" ] || [ $count -eq 5 ]; do
        count=$((count + 1))
        echo "     Rate limited or empty response. Retrying ($count/5)..."
        sleep 5
    done
    echo "${latest_versions}" > .python-versions.txt
    cat .python-versions.txt | head -n 1 > .python-version
    echo ".python-version:"
    cat .python-version
    echo ".python-versions.txt:"
    cat .python-versions.txt
}

function terraform()
{
    local image_registry="public.ecr.aws"
    local image_name="hashicorp/terraform"
    local count=0
    until latest_versions=$(crane ls "${image_registry}/${image_name}" 2>/dev/null | grep -E "${regex_patch_semver}" | sort -Vr) && [ -n "$latest_versions" ] || [ $count -eq 5 ]; do
        count=$((count + 1))
        echo "     Rate limited or empty response. Retrying ($count/5)..."
        sleep 5
    done
    echo "${latest_versions}" > .tf-versions.txt
    cat .tf-versions.txt | head -n 1 > .tf-version
    echo ".tf-version:"
    cat .tf-version
    echo ".tf-versions.txt:"
    cat .tf-versions.txt
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
