#!/usr/bin/env sh

# This script assumes at least `local` extension is present.
# shellcheck shell=ash

## Grab JSON response from the PaperMC API server
get_paper_api() {
    curl -sSL "https://papermc.io/api/v2/projects/paper$1"
}

## Check if the PaperMC version is available
is_available() {
    local version
    version="$1"

    get_paper_api "/versions/$version" \
        | jq -e 'has("project_id")' >/dev/null
}

get_paper() {
    # usage: get_paper [<minecraft version>]
    # If no version is specified, the latest version will be used.

    # Assign arguments
    local minecraft_version
    minecraft_version="$1"

    # If version is not supplied, get the latest version
    if [ -z "$minecraft_version" ]; then
        minecraft_version=$(get_paper_api | jq -r '.versions[-1]')
    fi

    # Verify that the version actually exists
    if ! is_available "$minecraft_version"; then
        echo "[get-paper] $minecraft_version is not a valid PaperMC version!" >&2
        echo "[get-paper] Tapping out..." >&2
        return 1
    fi

    # Find the latest build
    local build_number
    build_number=$(get_paper_api "/versions/$minecraft_version" | jq -r '.builds[-1]')

    # Download the JAR archive
    echo "[get-paper] Downloading PaperMC version $minecraft_version build $build_number..."
    curl -sSL -o paper.jar \
         "https://papermc.io/api/v2/projects/paper/versions/$minecraft_version/builds/$build_number/downloads/paper-$minecraft_version-$build_number.jar"
}

get_paper $@

