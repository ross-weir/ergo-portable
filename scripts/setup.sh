#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

GRAAL_ARCH=""
GRAAL_VERSION="22.0.0.2"
GRAAL_JAVA_VERSION="java11"
GU="gu"

ARCHIVE_EXT="tar.gz"

case $OSTYPE in
    msys*)
        ARCHIVE_EXT="zip"
        GRAAL_ARCH="windows"
        GU="${GU}.cmd"
        ;;
    linux*)
        GRAAL_ARCH="linux"
        ;;
    darwin*)
        GRAAL_ARCH="darwin"
        ;;
    *)
        echo "Unsupported os: $OSTYPE"
        ;;
esac

GRAAL_DOWNLOAD="https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-${GRAAL_JAVA_VERSION}-${GRAAL_ARCH}-amd64-${GRAAL_VERSION}.${ARCHIVE_EXT}"
GRAAL_ARCHIVE="graalvm.${ARCHIVE_EXT}"

echo "Downloading graal from ${GRAAL_DOWNLOAD}..."

curl -L -o $GRAAL_ARCHIVE $GRAAL_DOWNLOAD

echo "Extracting graalvm..."

if [[ "$ARCHIVE_EXT" == "zip" ]]; then
    unzip $GRAAL_ARCHIVE
else
    tar -xvzf $GRAAL_ARCHIVE
fi

if [[ "$OSTYPE" == "darwin"* ]]; then 
    GRAAL_BIN_PATH="graalvm-ce-${GRAAL_JAVA_VERSION}-${GRAAL_VERSION}/Contents/Home/bin"
else
    GRAAL_BIN_PATH="graalvm-ce-${GRAAL_JAVA_VERSION}-${GRAAL_VERSION}/bin"
fi

echo "Adding graalvm bin to GITHUB_PATH..."
echo "$GRAAL_BIN_PATH" >> $GITHUB_PATH

echo "Installing native-image..."
eval "${GRAAL_BIN_PATH}/${GU} install native-image"
