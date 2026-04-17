#!/bin/bash

set -euxo pipefail

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT
cd "$TMPDIR"

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

if [ $CLANG = "true" ]; then
    wget https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    ./llvm.sh 18 all
fi

if [ $RUST = "true" ]; then
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
    . "$HOME/.cargo/env"

    if [ $RIPGREP = "true" ]; then
        cargo install ripgrep
    fi

    if [ $FDFIND = "true" ]; then
        cargo install fd-find
    fi

    if [ $TREESITTER = "true" ]; then
        cargo install tree-sitter-cli
    fi
fi
