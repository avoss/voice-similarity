#!/usr/bin/env bash
set -e

#WINDOWS_WORKDIR="C:\\Users\\andreas\\workspace\\voice-similarity"
WINDOWS_WORKDIR="/$(pwd)"
LINUX_WORKDIR="//data"
IMAGE_NAME="voice-similarity"
TMPDIR="_normalized_audio"

if [ $# -lt 2 ]; then
  echo "Usage: bash run.sh old.wav new1.wav new2.wav ..."
  exit 1
fi

# Ensure Windows path escape for Docker
DOCKER_MOUNT_PATH="$WINDOWS_WORKDIR:$LINUX_WORKDIR"

# Prepare temp directory
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"

echo "Normalizing and resampling audio files..."

# Process audio files
for f in "$@"; do
  base=$(basename "$f")
  out="$TMPDIR/$base"

  ffmpeg -y -i "$f" \
    -ac 1 \
    -ar 24000 \
    -filter:a loudnorm \
    "$out" >/dev/null 2>&1

  echo "Processed: $f -> $out"
done

echo "Running similarity check..."

# Build the Docker argument list using Linux-style paths
docker_args=""
for f in "$@"; do
  base=$(basename "$f")
  docker_args="$docker_args $LINUX_WORKDIR/$TMPDIR/$base"
done

# Run Docker without Git Bash mangling the path
docker run --rm \
  -v "$DOCKER_MOUNT_PATH" \
  "$IMAGE_NAME" \
  $docker_args

echo "Done."
