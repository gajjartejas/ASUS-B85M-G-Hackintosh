[<img align="right" src="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/instagram.svg" width="50" height="50" />](http://www.instagram.com/gajjartejas)
[<img align="right" src="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/twitter.svg" width="50" height="50" />](http://www.twitter.com/gajjartejas)
[<img align="right" src="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/reddit.svg" width="50" height="50" />](http://www.reddit.com/u/gajjartejas)

# ASUS-B85M-G-Hackintosh (4th Generation - Haswell)

Goal of this repo is to run macOS on the ASUS B85M-G motherboard with OpenCore bootloader.

|         macOS Catalina 10.15.6         |           macOS Big Sur 11.2.3            |        macOS Ventura 13.3.1        |          macOS Sonoma 14.7.1           |              macOS 26.6.1               |
| :------------------------------------: | :---------------------------------------: | :--------------------------------: | :------------------------------------: | :-------------------------------------: |
| ![alt text](10.15.x/10.15.6/about.png) | ![alt text](11.0.x/11.2.3/screenshot.png) | ![alt text](13.x/13.3.1/about.png) | ![alt text](14.x/14.7.1/screenshot.png)| ![alt text](26.x/26.6.1/screenshot.png) |

## Hardware Info 💻

| Type         |                               Spec                                |  Status | Link                                                                                                     |
| ------------ | :---------------------------------------------------------------: | ------: | -------------------------------------------------------------------------------------------------------- |
| Motherboard  |                  ASUS B85M-G (mATX Form Factor)                   | Working | -                                                                                                        |
| BIOS Version |                         B85M-G BIOS 3602                          | Working | -                                                                                                        |
| CPU          |         Intel® Core™ i5-4590 Processor @ 3.30GHz (4-Core)         | Working | -                                                                                                        |
| Chipset      |                            Intel® B85                             | Working | -                                                                                                        |
| Memory       |                        28 GB 1600 MHz DDR3                        | Working | -                                                                                                        |
| Graphics     |                     AMD Radeon RX 6600 XT 8GB                     | Working | [NootRX](https://github.com/ChefKissInc/NootRX)                                                          |
| Audio        | Realtek® ALC887-VD2 8-Channel High Definition Audio + HDMI Audio  | Working | [AppleALC](https://github.com/acidanthera/AppleALC/wiki/Installation-and-usage)                         |
| Ethernet     |            Realtek® RTL8111G Gigabit LAN Controller(s)            | Working | -                                                                                                        |
| SMBIOS       |                             MacPro7,1                             | Working | -                                                                                                        |

## Extensions 🔨

| Type                                                                                                                    |                                                            Spec                                                             | Status  |
| ----------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------: | ------- |
| Graphics Card (Current)                                                                                                 |                                                  AMD Radeon RX 6600 XT 8GB                                                  | Working |
| Graphics Card (Alternative)                                                                                             |                                                     NITRO+ RX 580 8G G5                                                     | Working |
| [USB WiFi Adaptor](https://www.aliexpress.com/item/33059242651.html)                                                    |                      802.11AC NIC Realtek USB Adaptor Dual Band: Alternative 11AC(5.8G) and 11N(2.4G)                       | Working |
| [WiFi Card M.2 Card](https://www.aliexpress.com/item/4000329990755.html?spm=a2g0s.9042311.0.0.2cb24c4dnm2Qqt)           | BCM94360CS2 Wireless WIFI Bluetooth 4.0 Airport Card For Macbook Air 11" A1465 13" A1466 2013 MD711LL/A MD760 BCM94360CS2AX | Working |
| [NGFF M2 to PCIE AC Converter](https://www.aliexpress.com/item/4001028183672.html?spm=a2g0s.9042311.0.0.35844c4doSjGdi) |                        WTXUP NGFF M2 to PCIE AC Converter Adapter Card AX200 9260 8265 1650A for PC                         | Working |

## Important Notes ⚠️

### Intel HD4400 Graphics [Not supported on macOS Ventura and Newer]

Intel HD 4400 integrated graphics is deprecated and unsupported on newer macOS versions (macOS Ventura, Sonoma, and above). If running modern macOS, please disable Intel HD 4400 in the BIOS and use a compatible dedicated GPU (such as AMD RX 6600 XT via `NootRX.kext` or AMD Polaris RX 570 / RX 580 via `WhateverGreen.kext`).

If running legacy macOS with HD4400:
- Kernel -> Add -> Enable -> `WhateverGreen.kext`
- DeviceProperties -> Add `PciRoot(0x0)/Pci(0x2,0x0)` framebuffer patches.

### Dedicated GPU Configuration (RX 6600 XT)

When using Navi 23 GPUs such as AMD Radeon RX 6600 XT:
- Use `NootRX.kext` (do not load `WhateverGreen.kext` concurrently).
- SMBIOS `MacPro7,1` is recommended for optimal GPU power management and performance.

### Custom Serialization

Before booting, make sure to generate and add your own unique serials to `config.plist`:
- `PlatformInfo.Generic.SystemSerialNumber`
- `PlatformInfo.Generic.SystemUUID`
- `PlatformInfo.Generic.MLB`
- `PlatformInfo.Generic.ROM`

## Software Status 👨‍💻

| Feature                | Status  | Notes                                                   |
| ---------------------- | :-----: | ------------------------------------------------------- |
| Graphics Acceleration  | Working | Metal 3 full hardware acceleration with RX 6600 XT      |
| Onboard & HDMI Audio   | Working | Realtek ALC887 + HDMI Audio Output                      |
| Gigabit Ethernet (LAN) | Working | Realtek RTL8111G (en0)                                  |
| USB 2.0 & USB 3.0      | Working | Fully mapped via USBToolBox (`UTBMap.kext`)             |
| Bluetooth              | Working | RTL Bluetooth Firmware + BlueToolFixup                  |
| Sleep / Wake           | Working | Native power management with HibernationFixup           |
| App Store & Services   | Working | Requires unique SMBIOS serials                          |

### Kexts Used

| Kext                     | Info                                                                                                                                                                                  |
| ------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Lilu.kext                | Arbitrary kext and process patching engine for macOS                                                                                                                                  |
| VirtualSMC.kext          | SMC Emulator Layer                                                                                                                                                                    |
| SMCProcessor.kext        | Processor Temperature Monitoring                                                                                                                                                      |
| SMCSuperIO.kext          | Fan and Sensor Reading                                                                                                                                                                |
| NootRX.kext              | Open-source kernel extension for AMD RDNA2 dGPUs (Navi 23 / RX 6600 / RX 6600 XT)                                                                                                     |
| WhateverGreen.kext       | Various patches necessary for ATI/AMD Polaris/Intel/Nvidia GPUs (Alternative GPU setups)                                                                                              |
| AppleALC.kext            | Native macOS HD audio codec patching (Realtek ALC887)                                                                                                                                |
| AMFIPass.kext            | Allows AMFI to remain enabled while supporting root patch requirements                                                                                                                |
| RestrictEvents.kext      | Lilu Kernel extension for suppressing unwanted system popups and unlocking hardware-restricted features                                                                               |
| FeatureUnlock.kext       | Adds Sidecar, AirPlay, and Night Shift support to unsupported SMBIOS models                                                                                                           |
| RealtekRTL8111.kext      | Open-source macOS driver for Realtek RTL8111/8168 family Gigabit LAN                                                                                                                  |
| BlueToolFixup.kext       | Bluetooth stack fixup for macOS Monterey and newer                                                                                                                                   |
| RTLBluetoothFirmware.kext| Realtek Bluetooth firmware uploader                                                                                                                                                   |
| HibernationFixup.kext    | Resolves sleep and hibernation issues                                                                                                                                                 |
| USBToolBox.kext          | USB mapping companion kext                                                                                                                                                            |
| UTBMap.kext              | Custom USB port map for ASUS B85M-G                                                                                                                                                   |
| HoRNDIS.kext             | USB network driver for Android USB tethering                                                                                                                                          |
| RtWlanU.kext             | Realtek USB WiFi Adapter driver                                                                                                                                                       |
| RtWlanU1827.kext         | Realtek USB WiFi Adapter driver                                                                                                                                                       |

### SSDTs Used

| SSDT                | Info                                                                                                                                |
| :------------------ | :---------------------------------------------------------------------------------------------------------------------------------- |
| SSDT-EC.aml         | Embedded Controller fix for Haswell desktops ([Dortania Guide](https://dortania.github.io/Getting-Started-With-ACPI/Universal/ec-methods/prebuilt.html#wrapping-up)) |
| SSDT-PLUG.aml       | Native CPU power management plugin injection ([Dortania Guide](https://dortania.github.io/Getting-Started-With-ACPI/ssdt-methods/ssdt-prebuilt.html#desktop-haswell-and-broadwell)) |
| SSDT-SBUS-MCHC.aml  | Fixes SMBus and System Management Bus support for Haswell platforms                                                                |
| SSDT-USBX.aml       | USB power supply property injections for macOS                                                                                      |

### Credits

- [Apple](https://www.apple.com) for macOS.
- [Acidanthera](https://github.com/acidanthera) for OpenCorePkg and essential kexts.
- [ChefKissInc](https://github.com/ChefKissInc) for NootRX.
- [USBToolBox](https://github.com/USBToolBox) for USB mapping utilities.
- [Dortania](https://dortania.github.io/) for comprehensive Hackintosh guides.
- And everyone in the hackintosh community who contributed to open-source drivers and tools.
