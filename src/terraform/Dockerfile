# syntax=docker.io/docker/dockerfile:1

ARG alpine_version

FROM index.docker.io/library/alpine:${alpine_version} AS base

ARG alpine_version
ARG tf_version

USER root

ENV ALPINE_VERSION="${alpine_version}" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TF_VERSION="${tf_version}" \
    TZ="Asia/Singapore"

RUN apk add --no-cache tzdata

FROM base AS build

RUN apk add --no-cache curl unzip

RUN curl -fsSL "https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_$(case $(uname -m) in x86_64) echo amd64 ;; aarch64) echo arm64 ;; esac).zip" -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /tmp && \
    cp /tmp/terraform /usr/local/bin/terraform && \
    chmod +x /usr/local/bin/terraform

FROM base AS final

COPY --from=build /usr/local/bin/terraform /usr/local/bin

WORKDIR /root
