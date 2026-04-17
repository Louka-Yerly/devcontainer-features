#!/bin/bash

set -eux

EXTRACTED_DIR_NAME="nvim-linux-x86_64"
INSTALL_PATH="/opt"
COMPRESSED_FILE_NAME="${EXTRACTED_DIR_NAME}.tar.gz"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

cd "$TMPDIR"

apt update
apt install -y wget

wget "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/${COMPRESSED_FILE_NAME}"
tar -xvf "$COMPRESSED_FILE_NAME"
rm "$COMPRESSED_FILE_NAME"

mv ${EXTRACTED_DIR_NAME} ${INSTALL_PATH}/nvim

# Add to PATH
echo 'export PATH="$PATH:${INSTALL_PATH}/nvim/bin"' >> ~/.bashrc

# copy man pages
if [ -d ${EXTRACTED_DIR_NAME}/man ]; then
  cp -r ${EXTRACTED_DIR_NAME}/man/* /usr/local/man
fi
