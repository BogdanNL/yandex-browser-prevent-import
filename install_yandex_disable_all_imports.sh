#!/bin/sh
set -eu
umask 022

POLICY_DIR="/etc/opt/yandex/browser/policies/managed"
POLICY_FILE="$POLICY_DIR/disable_all_imports.json"

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: run this script as root (for example: sudo $0)" >&2
    exit 1
fi

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SOURCE_FILE="$SCRIPT_DIR/yandex_disable_all_imports.json"

if [ ! -r "$SOURCE_FILE" ]; then
    echo "ERROR: policy file not found or not readable: $SOURCE_FILE" >&2
    exit 1
fi

install -d -o root -g root -m 0755 "$POLICY_DIR"

# Prepare the entire file before publishing it to the policy loader.
TEMP_FILE=$(mktemp "$POLICY_DIR/.disable_all_imports.XXXXXX")
trap 'rm -f -- "$TEMP_FILE"' EXIT
trap 'exit 1' HUP INT TERM
cat "$SOURCE_FILE" > "$TEMP_FILE"
chown root:root "$TEMP_FILE"
chmod 0644 "$TEMP_FILE"
mv -fT -- "$TEMP_FILE" "$POLICY_FILE"

echo "Yandex Browser managed import policies installed:"
echo "  $POLICY_FILE"
echo
echo "After Yandex Browser is installed, verify them at:"
echo "  browser://policy"
