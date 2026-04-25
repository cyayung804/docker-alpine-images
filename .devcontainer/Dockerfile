# syntax=docker.io/docker/dockerfile:1

ARG ubuntu_version=24.04

FROM index.docker.io/library/ubuntu:${ubuntu_version} AS base

USER root

ENV TZ="Asia/Singapore"

RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.asc] "https://download.docker.com/linux/ubuntu" noble stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    make

WORKDIR /workspaces

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
