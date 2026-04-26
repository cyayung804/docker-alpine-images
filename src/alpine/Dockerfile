# syntax=docker.io/docker/dockerfile:1

ARG alpine_version

FROM public.ecr.aws/docker/library/alpine:${alpine_version} AS base

ARG alpine_version

USER root

ENV ALPINE_VERSION="${alpine_version}" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Singapore"

RUN apk add --no-cache tzdata
