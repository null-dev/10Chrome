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

scriptEcho "Preconfiguring container - Updating APT sources..."
sudo apt-get update
scriptEcho "Preconfiguring container - Installing required debian packages..."
sudo apt-get install realpath

scriptEcho "Cloning and setting up depot_tools..."
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:$(realpath depot_tools)"

scriptEcho "Getting core chromium source code..."
mkdir chromium
pushd chromium
fetch --no-history --nohooks android
pushd src

scriptEcho "Installing additional build dependencies..."
build/install-build-deps-android.sh

scriptEcho "Running chromium hooks..."
gclient runhooks

scriptEcho "Creating build configuration..."
gn gen --args='target_os="android" is_debug=false dcheck_always_on=false is_component_build=false symbol_level=0 enable_nacl=true remove_webcore_debug_symbols=true' out/Default

scriptEcho "Building chromium..."
ninja -C out/Default chrome_public_apk
