#!/bin/sh

set -e

dockerd &

until docker info >/dev/null 2>&1; do
  echo "Waiting for dockerd to start..."
  sleep 1
done

echo "Docker daemon is up and running."

exec tail -f /dev/null
