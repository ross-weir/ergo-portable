#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

NATIVE_IMAGE="native-image"

if [[ "$OSTYPE" == "msys"* ]]; then
    NATIVE_IMAGE="${NATIVE_IMAGE}.cmd"
fi

eval "${NATIVE_IMAGE} -jar ergo.jar --allow-incomplete-classpath -H:ConfigurationFileDirectories=conf"
