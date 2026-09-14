#!/bin/bash

# Extract OpenCore EFI folder without sensitive serial numbers, UUIDs, or MLB keys.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}"
TEMP_OC_DIR="${OUTPUT_DIR}/OC"

INPUT_SOURCE="${1:-}"

# Clean up any leftover temporary folder
rm -rf "${TEMP_OC_DIR}"

if [ -z "${INPUT_SOURCE}" ]; then
  if [ -d "/Volumes/EFI/EFI/OC" ]; then
    echo "Found EFI at /Volumes/EFI/EFI/OC"
    cp -R "/Volumes/EFI/EFI/OC" "${TEMP_OC_DIR}"
  elif [ -d "${SCRIPT_DIR}/../../OC" ]; then
    echo "Found OC directory at ${SCRIPT_DIR}/../../OC"
    cp -R "${SCRIPT_DIR}/../../OC" "${TEMP_OC_DIR}"
  else
    echo "Usage: $0 [/dev/diskXsY | /path/to/OC | /Volumes/EFI/EFI/OC]"
    exit 1
  fi
elif [ -d "${INPUT_SOURCE}" ]; then
  echo "Copying from directory: ${INPUT_SOURCE}"
  cp -R "${INPUT_SOURCE}" "${TEMP_OC_DIR}"
elif [[ "${INPUT_SOURCE}" =~ ^/dev/disk ]]; then
  echo "Mounting EFI partition: ${INPUT_SOURCE}"
  sudo diskutil mount "${INPUT_SOURCE}"
  if [ -d "/Volumes/EFI/EFI/OC" ]; then
    cp -R "/Volumes/EFI/EFI/OC" "${TEMP_OC_DIR}"
  elif [ -d "/Volumes/ESP/EFI/OC" ]; then
    cp -R "/Volumes/ESP/EFI/OC" "${TEMP_OC_DIR}"
  else
    echo "Error: OpenCore directory not found on mounted EFI volume."
    exit 1
  fi
else
  echo "Invalid argument: ${INPUT_SOURCE}"
  exit 1
fi

CONFIG_PLIST="${TEMP_OC_DIR}/config.plist"

if [ -f "${CONFIG_PLIST}" ]; then
  echo "Sanitizing serial numbers and hardware identifiers..."

  # Helper function to replace plist values if key exists
  sanitize_key() {
    local key_path="$1"
    local dummy_val="$2"
    plutil -replace "${key_path}" -string "${dummy_val}" "${CONFIG_PLIST}" 2>/dev/null || true
  }

  # DataHub
  sanitize_key "PlatformInfo.DataHub.SystemSerialNumber" "PLEASE INSERT YOUR OWN"
  sanitize_key "PlatformInfo.DataHub.SystemUUID" "PLEASE INSERT YOUR OWN"

  # Generic
  sanitize_key "PlatformInfo.Generic.SystemSerialNumber" "PLEASE INSERT YOUR OWN"
  sanitize_key "PlatformInfo.Generic.SystemUUID" "PLEASE INSERT YOUR OWN"
  sanitize_key "PlatformInfo.Generic.MLB" "PLEASE INSERT YOUR OWN"

  # SMBIOS
  sanitize_key "PlatformInfo.SMBIOS.BoardSerialNumber" "PLEASE INSERT YOUR OWN"
  sanitize_key "PlatformInfo.SMBIOS.ChassisSerialNumber" "PLEASE INSERT YOUR OWN"
  sanitize_key "PlatformInfo.SMBIOS.SystemSerialNumber" "PLEASE INSERT YOUR OWN"
  sanitize_key "PlatformInfo.SMBIOS.SystemUUID" "PLEASE INSERT YOUR OWN"

  echo "Config plist sanitized successfully."
else
  echo "Warning: config.plist not found in extracted OC folder."
fi

# Detect OpenCore version from NVRAM or fallback
Version=$(nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version 2>/dev/null | sed -n 's/.*REL-*//p' | sed -e 's/-/_/g')
if [ -z "${Version}" ]; then
  Version=$(date +'%Y_%m_%d')
fi

ZIP_FILE="${OUTPUT_DIR}/OC_${Version}.zip"
echo "Creating archive: ${ZIP_FILE}"
ditto -c -k --sequesterRsrc --keepParent "${TEMP_OC_DIR}" "${ZIP_FILE}"
rm -rf "${TEMP_OC_DIR}"

echo "Done! Generated: ${ZIP_FILE}"
exit 0
