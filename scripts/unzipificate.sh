#!/usr/bin/env bash
for f in "$@"; do
    unzip "$f" -d "${f%.*}"
done
