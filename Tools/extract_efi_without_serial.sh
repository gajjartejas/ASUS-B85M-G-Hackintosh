#!/bin/bash

# Extract OpenCore EFI folder with standard EFI/ (OC & BOOT) structure,
# without sensitive serial numbers, UUIDs, or MLB keys.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}"
TEMP_DIR="${OUTPUT_DIR}/_tmp_efi_extract"
TEMP_EFI_DIR="${TEMP_DIR}/EFI"
TEMP_OC_DIR="${TEMP_EFI_DIR}/OC"
TEMP_BOOT_DIR="${TEMP_EFI_DIR}/BOOT"

INPUT_SOURCE="${1:-}"
CUSTOM_EFI_PATH="${2:-}"

# Clean up temporary folders
rm -rf "${TEMP_DIR}"
mkdir -p "${TEMP_OC_DIR}" "${TEMP_BOOT_DIR}"

SOURCE_OC_DIR=""
SOURCE_BOOT_DIR=""

if [ -n "${INPUT_SOURCE}" ] && [ -d "${INPUT_SOURCE}" ]; then
  if [ -d "${INPUT_SOURCE}/OC" ]; then
    # Given path is an EFI folder containing OC/
    SOURCE_OC_DIR="${INPUT_SOURCE}/OC"
    [ -d "${INPUT_SOURCE}/BOOT" ] && SOURCE_BOOT_DIR="${INPUT_SOURCE}/BOOT"
  elif [ -f "${INPUT_SOURCE}/config.plist" ] || [ -f "${INPUT_SOURCE}/OpenCore.efi" ]; then
    # Given path is directly the OC folder
    SOURCE_OC_DIR="${INPUT_SOURCE}"
    PARENT_DIR="$(dirname "${INPUT_SOURCE}")"
    [ -d "${PARENT_DIR}/BOOT" ] && SOURCE_BOOT_DIR="${PARENT_DIR}/BOOT"
  else
    SOURCE_OC_DIR="${INPUT_SOURCE}"
  fi

elif [ -n "${INPUT_SOURCE}" ] && [[ "${INPUT_SOURCE}" =~ ^(/dev/)?disk[0-9]+s[0-9]+ ]]; then
  # Disk partition identifier passed (e.g., /dev/disk0s1 or disk0s1)
  DEVICE="${INPUT_SOURCE}"
  [[ "${DEVICE}" != /dev/* ]] && DEVICE="/dev/${DEVICE}"

  echo "Mounting EFI partition: ${DEVICE}"
  if ! diskutil mount "${DEVICE}" 2>/dev/null; then
    sudo diskutil mount "${DEVICE}"
  fi

  if [ -n "${CUSTOM_EFI_PATH}" ] && [ -d "${CUSTOM_EFI_PATH}" ]; then
    SOURCE_OC_DIR="${CUSTOM_EFI_PATH}"
  elif [ -d "/Volumes/EFI/EFI/OC" ]; then
    SOURCE_OC_DIR="/Volumes/EFI/EFI/OC"
    [ -d "/Volumes/EFI/EFI/BOOT" ] && SOURCE_BOOT_DIR="/Volumes/EFI/EFI/BOOT"
  elif [ -d "/Volumes/ESP/EFI/OC" ]; then
    SOURCE_OC_DIR="/Volumes/ESP/EFI/OC"
    [ -d "/Volumes/ESP/EFI/BOOT" ] && SOURCE_BOOT_DIR="/Volumes/ESP/EFI/BOOT"
  else
    echo "Error: OpenCore directory (EFI/OC) not found on mounted EFI volume."
    rm -rf "${TEMP_DIR}"
    exit 1
  fi

elif [ -z "${INPUT_SOURCE}" ]; then
  # Auto-detection from already mounted EFI volume
  if [ -d "/Volumes/EFI/EFI/OC" ]; then
    SOURCE_OC_DIR="/Volumes/EFI/EFI/OC"
    [ -d "/Volumes/EFI/EFI/BOOT" ] && SOURCE_BOOT_DIR="/Volumes/EFI/EFI/BOOT"
  elif [ -d "/Volumes/ESP/EFI/OC" ]; then
    SOURCE_OC_DIR="/Volumes/ESP/EFI/OC"
    [ -d "/Volumes/ESP/EFI/BOOT" ] && SOURCE_BOOT_DIR="/Volumes/ESP/EFI/BOOT"
  else
    echo "Usage:"
    echo "  $0 /path/to/OC"
    echo "  $0 /path/to/EFI"
    echo "  $0 /dev/disk0s1"
    echo "  $0 (if EFI is already mounted at /Volumes/EFI)"
    rm -rf "${TEMP_DIR}"
    exit 1
  fi
else
  echo "Invalid argument: ${INPUT_SOURCE}"
  rm -rf "${TEMP_DIR}"
  exit 1
fi

echo "Copying OpenCore files from: ${SOURCE_OC_DIR}"
cp -R "${SOURCE_OC_DIR}/"* "${TEMP_OC_DIR}/"

if [ -n "${SOURCE_BOOT_DIR}" ] && [ -d "${SOURCE_BOOT_DIR}" ]; then
  echo "Copying BOOT files from: ${SOURCE_BOOT_DIR}"
  cp -R "${SOURCE_BOOT_DIR}/"* "${TEMP_BOOT_DIR}/"
else
  # Ensure standard OpenCore BOOT folder exists
  echo "Creating standard BOOT folder with OpenCore bootstrap..."
  if [ -f "/tmp/oc_107/X64/EFI/BOOT/BOOTx64.efi" ]; then
    cp -R /tmp/oc_107/X64/EFI/BOOT/* "${TEMP_BOOT_DIR}/"
  elif [ -f "${TEMP_OC_DIR}/OpenCore.efi" ]; then
    cp "${TEMP_OC_DIR}/OpenCore.efi" "${TEMP_BOOT_DIR}/BOOTx64.efi"
  fi
fi

CONFIG_PLIST="${TEMP_OC_DIR}/config.plist"

if [ -f "${CONFIG_PLIST}" ]; then
  echo "Sanitizing serial numbers and hardware identifiers..."

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
rm -f "${ZIP_FILE}"

echo "Creating archive with EFI/ (OC and BOOT) folder structure: ${ZIP_FILE}"
(cd "${TEMP_DIR}" && zip -r -q -X "${ZIP_FILE}" EFI)
rm -rf "${TEMP_DIR}"

echo "Done! Generated: ${ZIP_FILE}"
exit 0
