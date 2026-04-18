#!/bin/bash

set -e

source dev-container-features-test-lib

check "validate dotfiles" ls $HOME/test/gitignore | grep "gitignore"

reportResults
