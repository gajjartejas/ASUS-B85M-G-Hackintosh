### Changelog

1. macOS 26.6.1 support added.
2. OpenCore version updated to 1.0.7 (REL-107-2026-03-20).
3. SMBIOS configured to `MacPro7,1`.
4. Added AMD Radeon RX 6600 XT 8GB (Navi 23) dGPU acceleration with Metal 3 support via `NootRX.kext`.
5. Added `AMFIPass.kext`, `UTBMap.kext`, and `RTLBluetoothFirmware.kext`.
6. Updated ACPI SSDTs (`SSDT-SBUS-MCHC.aml`, `SSDT-EC.aml`, `SSDT-PLUG.aml`, `SSDT-USBX.aml`).
7. Updated core kexts (`Lilu`, `VirtualSMC`, `AppleALC`, `RestrictEvents`, `FeatureUnlock`, `BlueToolFixup`, etc.).

### Hardware Specifications

- **Motherboard**: ASUS B85M-G (BIOS 3602)
- **Processor**: Intel® Core™ i5-4590 (4th Gen Haswell, 4 Cores / 4 Threads @ 3.30GHz, Turbo 3.70GHz)
- **Memory**: 28 GB DDR3 1600 MHz
- **Graphics**: AMD Radeon RX 6600 XT 8GB GDDR6 (Metal 3 supported)
- **Audio**: Realtek® ALC887 + HDMI Audio on LG FHD (1080p @ 120Hz)
- **Ethernet**: Realtek® RTL8111G PCIe Gigabit LAN (`en0`)
- **Wireless**: Realtek 802.11ac USB Wi-Fi + RTL Bluetooth USB
- **Storage**: Samsung SSD 860 EVO 500GB SATA SSD + WD 1TB SATA HDD

### What's Working/Not Working

1. Full GPU Acceleration on AMD Radeon RX 6600 XT with Metal 3 support.
2. Onboard Audio (Realtek ALC887) and HDMI Audio output.
3. Gigabit Ethernet (Realtek RTL8111G).
4. Wi-Fi and Bluetooth via USB adapters.
5. Full USB 2.0 & USB 3.0 mapping via USBToolBox (`UTBMap.kext`).
6. Native Power Management, Sleep & Wake.
7. Android USB Tethering via `HoRNDIS.kext`.
8. Intel HD Graphics 4600 integrated graphics is deprecated/unsupported on modern macOS — using dedicated AMD RX 6600 XT.

### Important

Please add your own `SystemSerialNumber`, `SystemUUID`, and `MLB` in `config.plist`.
Please back up your system and EFI before upgrading.

### Download

Please check the Releases section to download the pre-configured OpenCore EFI zip (`OC_107_2026_03_20.zip`).
