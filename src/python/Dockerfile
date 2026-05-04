# syntax=docker.io/docker/dockerfile:1

ARG alpine_version

FROM index.docker.io/library/alpine:${alpine_version} AS base

ARG alpine_version
ARG python_version

USER root

ENV ALPINE_VERSION="${alpine_version}" \
    PYTHON_VERSION="${python_version}" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Singapore"

RUN apk add --no-cache tzdata \
    autoconf \
    build-base \
    linux-headers

FROM base AS build

WORKDIR /build

COPY ./src/${alpine_version}/${python_version}/Python-${python_version}.tgz .

RUN --mount=type=cache,target=/root/.cache \
    apk add --no-cache git gzip tar && \
    tar -xvf Python-${python_version}.tgz && \
    cd Python-${python_version} && \
    ./configure --enable-optimizations && \
    make && \
    make install

FROM base AS final

COPY --from=build /usr/local /usr/local

WORKDIR /
