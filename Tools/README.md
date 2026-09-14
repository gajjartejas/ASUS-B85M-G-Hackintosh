# Tools

### extract_efi_without_serial.sh

Use this script to extract and package your OpenCore `OC` folder into a zip archive while sanitizing private identifiers (`SystemSerialNumber`, `SystemUUID`, `MLB`, `ROM`, and `SMBIOS` serial keys).

#### Usage:

1. **Direct Path (Recommended)**:
```bash
./Tools/extract_efi_without_serial.sh /path/to/OC
```

2. **Mounted EFI Partition**:
```bash
# First identify your EFI partition (e.g., /dev/disk0s1)
diskutil list

# Run the extraction script with the device path:
./Tools/extract_efi_without_serial.sh /dev/disk0s1
```

3. **Auto-Detection**:
If no argument is passed, the script checks mounted EFI volumes at `/Volumes/EFI/EFI/OC` or `/Volumes/ESP/EFI/OC`.
```bash
./Tools/extract_efi_without_serial.sh
```

#### Output:
The script automatically reads the OpenCore version and release date from NVRAM (or timestamp) to generate the archive:
```
Tools/OC_<OpenCoreVersion>_<ReleaseDate>.zip
```

Example:
```
Tools/OC_107_2026_03_20.zip
```
