#!/bin/bash

PLUGIN=$1
DYLIB_PATH=$2

usage() {
    cat <<HEREDOC
Generates a macOS bundle from a compiled dylib file

Usage:
    $0 plugin-name path/to/plugin.dylib
HEREDOC
    exit 1
}

[[ -z ${PLUGIN} || -z ${DYLIB_PATH} ]] && usage

set -euo pipefail

# Make the bundle folder
mkdir -p "${PLUGIN}.vst/Contents/MacOS"

# Create the PkgInfo
echo "BNDL????" > "${PLUGIN}.vst/Contents/PkgInfo"

#build the Info.Plist
cat <<HEREDOC> "${PLUGIN}.vst/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>English</string>

    <key>CFBundleExecutable</key>
    <string>${PLUGIN}</string>

    <key>CFBundleGetInfoString</key>
    <string>vst</string>

    <key>CFBundleIconFile</key>
    <string></string>

    <key>CFBundleIdentifier</key>
    <string>com.rust-vst.${PLUGIN}</string>

    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>

    <key>CFBundleName</key>
    <string>${PLUGIN}</string>

    <key>CFBundlePackageType</key>
    <string>BNDL</string>

    <key>CFBundleVersion</key>
    <string>1.0</string>

    <key>CFBundleSignature</key>
    <string>$((RANDOM % 9999))</string>

    <key>CSResourcesFileMapped</key>
    <string></string>

</dict>
</plist>
HEREDOC

# move the provided library to the correct location
cp "${DYLIB_PATH}" "${PLUGIN}.vst/Contents/MacOS/${PLUGIN}"

echo "Created bundle ${PLUGIN}.vst"
