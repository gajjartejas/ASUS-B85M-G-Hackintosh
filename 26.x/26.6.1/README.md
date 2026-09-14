### Changelog

1. macOS 26.6.1 support added.
2. OpenCore version updated to 1.0.7.
3. SMBIOS updated to `MacPro7,1`.
4. Added AMD Radeon RX 6600 XT 8GB support via `NootRX.kext`.
5. Added `AMFIPass.kext`, `UTBMap.kext`, and `RTLBluetoothFirmware.kext`.
6. Updated ACPI SSDTs (`SSDT-SBUS-MCHC.aml`, `SSDT-EC.aml`, `SSDT-PLUG.aml`, `SSDT-USBX.aml`).
7. Updated kexts (`Lilu`, `VirtualSMC`, `AppleALC`, `RestrictEvents`, `FeatureUnlock`, `BlueToolFixup`, etc.).

### What's Working/Not Working

1. AMD Radeon RX 6600 XT Hardware Acceleration (Metal 3, Full Acceleration via NootRX).
2. Audio (Realtek ALC887 onboard audio + HDMI Audio via RX 6600 XT).
3. Ethernet (Realtek RTL8111G Gigabit LAN).
4. Bluetooth & WiFi.
5. USB 2.0 and USB 3.0 ports (custom mapped via USBToolBox / UTBMap).
6. Power Management / Sleep / Wake.
7. Intel HD4400 is not supported on newer macOS versions — use a compatible dedicated GPU such as AMD RX 6600 XT or RX 580.

### Important

Please add your own `SystemSerialNumber`, `SystemUUID`, and `MLB` to `config.plist`.
Please back up your system and EFI before upgrading.

### Download

Please check the Releases section to download the EFI build.
