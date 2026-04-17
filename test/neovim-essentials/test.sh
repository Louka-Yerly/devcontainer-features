#!/bin/bash

set -e

source dev-container-features-test-lib

check "validate neovim-essentials" echo "Ok"

reportResults
