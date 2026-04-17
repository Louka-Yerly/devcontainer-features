#!/bin/bash

set -eux

source_os_release() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID" "$VERSION_ID"
    else
        echo "/etc/os-release file was not found in the container" >&2
        echo "This file is required for the installation" >&2
        exit 1
    fi
}

has_matching_version() {
    IFS="." read -r -a start <<<"$1"
    IFS="." read -r -a end <<<"$2"
    IFS="." read -r -a version <<<"$3"

    if [ ${version[0]} -gt ${start[0]} ] && [ ${version[0]} -lt ${end[0]} ]; then
        echo 1
        return
    fi

    if [ ${version[0]} = ${start[0]} ]; then
        for ((i = 0; i < ${#version[@]}; i++)); do
            if [ ${version[i]} -lt ${start[i]} ]; then
                echo 0
                return
            fi
        done

        echo 1
        return
    fi

    if [ ${version[0]} = ${end[0]} ]; then
        for ((i = 0; i < ${#version[@]}; i++)); do
            if [ ${version[i]} -gt ${end[i]} ]; then
                echo 0
                return
            fi
        done

        echo 1
        return
    fi

    echo 0
}

os_id_version_from_file() {
    # extract the file name
    local installer_filename="$(basename $1)"

    # remove the file extension
    installer_filename="${installer_filename%.*}"

    IFS="-" read -r os_release_id os_release_version_start os_release_version_end  <<< "$installer_filename"

    echo "$os_release_id $os_release_version_start $os_release_version_end"
}

source_matching_installer() {
    read -r os_release_id os_release_version_id <<< "$(source_os_release)"

    for installer in "installers/$os_release_id"*; do

        read -r installer_os installer_version_start installer_version_end <<<"$(os_id_version_from_file $installer)"
        read -r is_match <<<"$(has_matching_version $installer_version_start $installer_version_end $os_release_version_id)"

        if [ $is_match -eq 1 ]; then
            . "$installer"
        else
            echo "No matching installer found for $curr_os $curr_os_version" >&2
            exit 1
        fi
    done
}
