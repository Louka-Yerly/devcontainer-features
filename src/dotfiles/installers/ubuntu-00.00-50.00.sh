#!/bin/bash

set -eux

IFS=',' read -ra repos <<< "$DOTFILE_REPOS"
IFS=',' read -ra paths <<< "$DOTFILE_PATHS"

if [[ ${#repos[@]} -ne ${#paths[@]} ]]; then
  echo "Error: number of repos (${#repos[@]}) does not match number of paths (${#paths[@]})"
  exit 1
fi

for i in "${!repos[@]}"; do
  repo="${repos[$i]}"
  path="${paths[$i]}"
  git clone "$repo" "$path"
done
