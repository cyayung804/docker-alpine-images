# syntax=docker.io/docker/dockerfile:1

ARG alpine_version

FROM index.docker.io/library/alpine:${alpine_version} AS base

ARG alpine_version
ARG go_version

USER root

ENV ALPINE_VERSION="${alpine_version}" \
    GO_VERSION="${go_version}" \
    GOPATH="/go" \
    GOTOOLCHAIN="local" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Singapore"

ENV PATH="${PATH}:/go/bin:/usr/local/go/bin"

RUN apk add --no-cache make tzdata

WORKDIR /go

FROM base AS build

ARG go_version

RUN apk add --no-cache curl gzip tar \
    && go_package="go${GO_VERSION}.linux-$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).tar.gz" \
    && curl -fsSL "https://go.dev/dl/${go_package}" -o "/usr/local/${go_package}" \
    && tar -xf "/usr/local/${go_package}" -C /usr/local \
    && mv "/usr/local/${go_package}" /usr/local/go

FROM base AS final

COPY --from=build /usr/local/go /usr/local/
