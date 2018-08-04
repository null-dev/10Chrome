#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail

# Print all commands executed
set -o xtrace

function scriptEcho() {
    echo ">>> $1"
}

scriptEcho "Building Chrome $1..."

scriptEcho "Cloning depot_tools..."
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

