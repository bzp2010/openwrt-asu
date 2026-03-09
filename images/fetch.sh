#!/usr/bin/env bash
set -e

IMAGES=(
  openwrt/asu:latest

  # Add more images here if needed
  # ghcr.io/openwrt/imagebuilder:x86-64
)

rm -f ./*.tgz 2>/dev/null || true

for IMAGE in "${IMAGES[@]}"; do
  echo "Pulling $IMAGE ..."
  docker pull "$IMAGE"

  FILE=$(echo "$IMAGE" | sed 's#[/:]#_#g').tgz

  echo "Saving $IMAGE -> $FILE ..."
  docker save "$IMAGE" | gzip > "$FILE"
done

echo "All images saved."
