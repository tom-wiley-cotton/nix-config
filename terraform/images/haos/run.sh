#!/usr/bin/env bash

# Exit on error
set -e

# Parse command line arguments
IMPORT=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -i|--import) IMPORT=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Function to get latest version
get_latest_version() {
    curl -s https://api.github.com/repos/home-assistant/operating-system/releases/latest | \
    grep '"tag_name":' | \
    sed -E 's/.*"([^"]+)".*/\1/' | \
    sed 's/v//'
}

# Get latest version
VERSION=$(get_latest_version)
if [ -z "$VERSION" ]; then
    echo "Error: Failed to get latest version"
    exit 1
fi
echo "Latest version: $VERSION"

# Download latest qcow2.xz
FILENAME="haos_ova-${VERSION}.qcow2.xz"
URL="https://github.com/home-assistant/operating-system/releases/download/${VERSION}/${FILENAME}"
echo "Downloading $URL"

# Download with error checking
if ! curl -L -f -o "$FILENAME" "$URL"; then
    echo "Error: Failed to download $URL"
    exit 1
fi

# Check file size
if [ ! -s "$FILENAME" ]; then
    echo "Error: Downloaded file is empty"
    rm -f "$FILENAME"
    exit 1
fi

# Extract the image
echo "Extracting qcow2 image..."
if ! xz -d "$FILENAME"; then
    echo "Error: Failed to extract $FILENAME"
    exit 1
fi

# Create metadata.yaml
cat > metadata.yaml << EOF
architecture: x86_64
creation_date: $(date +%s)
properties:
  description: Home Assistant OS
  os: HAOS
  release: ${VERSION}
EOF

# Create metadata archive
echo "Creating metadata archive..."
tar -czf metadata.tar.gz metadata.yaml

QCOW2_FILE="haos_ova-${VERSION}.qcow2"

if [ "$IMPORT" = true ]; then
    # Import to incus
    echo "Importing to incus..."
    if ! sudo incus image import metadata.tar.gz "$QCOW2_FILE" --alias haos; then
        echo "Error: Failed to import image to incus"
        exit 1
    fi
    
    # Cleanup after import
    echo "Cleaning up temporary files..."
    rm -f metadata.yaml metadata.tar.gz "$QCOW2_FILE"
    echo "Done! Image imported with alias 'haos'"
else
    echo "Files prepared:"
    echo "- $QCOW2_FILE (HAOS image)"
    echo "- metadata.tar.gz (metadata archive)"
    echo "To import manually, run:"
    echo "sudo incus image import metadata.tar.gz $QCOW2_FILE --alias haos"
fi

# incus launch haos HomeAssistant-OS --vm -c security.secureboot=false -c limits.cpu=2 -c limits.memory=4GiB -d root,size=32GiB
