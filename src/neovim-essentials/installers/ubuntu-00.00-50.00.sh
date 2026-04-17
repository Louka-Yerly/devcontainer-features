#!/bin/bash

set -euxo pipefail

apt update

env

pkgs=()

if [ $GIT = "true" ]; then
  pkgs+=("git")
fi

if [ $BUILD_ESSENTIAL = "true" ]; then
  pkgs+=("build-essential")
fi

if [ $WGET = "true" ]; then
  pkgs+=("wget")
fi

if [ $CURL = "true" ]; then
  pkgs+=("curl")
fi

if [ $PYTHON3 = "true" ]; then
  pkgs+=("python3")
fi

if [ $PIP3 = "true" ]; then
  pkgs+=("python3-pip")
fi

if [ $UNZIP = "true" ]; then
  pkgs+=("unzip")
fi

echo "${pkgs[@]}"

apt install -y "${pkgs[@]}"

if [ $RUST = "true" ]; then
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
    . "$HOME/.cargo/env"

    if [ $RIPGREP = "true" ]; then
        cargo install ripgrep
    fi

    if [ $FDFIND = "true" ]; then
        cargo install fd-find
    fi
fi
