# Voice Similarity Tool

A simple tool to determine which TTS voice sounds most similar to a reference audio sample.
It normalizes audio files, computes voice embeddings using Resemblyzer, and ranks similarity
using cosine distance. Everything runs inside Docker with a minimal CLI wrapper script.

## Features

- Neural voice embeddings (Resemblyzer)
- Automatic audio preprocessing (24 kHz, mono, loudness-normalized)
- Fully containerized environment
- Simple usage: `bash run.sh old.wav new*.wav`
- Works on Windows using Git Bash

## Requirements

- Docker Desktop
- Git Bash (Windows) or any Bash shell
- `ffmpeg` installed on the host
- WAV files (one reference + multiple candidates)

## Setup

    docker build -t voice-similarity .

## Usage

    bash run.sh old.wav new*.wav

The script will:
1. Convert and normalize all audio files into `_normalized_audio/`
2. Run the Docker container
3. Print a similarity ranking (highest = most similar)

Example output:

    Most similar voices:
    voice17.wav: similarity = 0.8123
    voice05.wav: similarity = 0.7991
    ...

## File Overview

    Dockerfile                    # Python + ffmpeg environment
    find_most_similar_voice.py    # Embedding + similarity computation
    run.sh                        # Audio preprocessing + Docker execution

## Windows Notes

Git Bash may rewrite POSIX-style paths. To avoid this, `run.sh` can use:

    WINDOWS_WORKDIR="/$(pwd)"
    LINUX_WORKDIR="//data"

These ensure volume mounting works correctly on Windows.

## License

MIT
