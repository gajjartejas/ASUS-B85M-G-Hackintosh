[<img align="right" src="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/instagram.svg" width="50" height="50" />](http://www.instagram.com/gajjartejas)
[<img align="right" src="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/twitter.svg" width="50" height="50" />](http://www.twitter.com/gajjartejas)
[<img align="right" src="https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/reddit.svg" width="50" height="50" />](http://www.reddit.com/u/gajjartejas)

# ASUS-B85M-G-Hackintosh (4th Generation - Haswell)

Goal of this repo is to run Mac os on ASUS B85M-G.

|         macOS Catalina 10.15.6         |           macOS Big Sur 11.2.3            |        macOS Ventura 13.3.1        |          macOS Ventura 14.7.1           |
| :------------------------------------: | :---------------------------------------: | :--------------------------------: | :-------------------------------------: |
| ![alt text](10.15.x/10.15.6/about.png) | ![alt text](11.0.x/11.2.3/screenshot.png) | ![alt text](13.x/13.3.1/about.png) | ![alt text](14.x/14.7.1/screenshot.png) |

## Hardware Info 💻

| Type         |                           Spec                            |  Status | Link                                                                                                     |
| ------------ | :-------------------------------------------------------: | ------: | -------------------------------------------------------------------------------------------------------- |
| Motherboard  |              ASUS B85M-G (mATX Form Factor)               | Working | -                                                                                                        |
| BIOS Version |                     B85M-G BIOS 3602                      | Working | -                                                                                                        |
| CPU          |              Intel® Core™ i3-4160 Processor               | Working | -                                                                                                        |
| Chipset      |                        Intel® B85                         | Working | -                                                                                                        |
| Graphics     |                  Intel® HD Graphics 4400                  | Working | [Guide](https://www.tonymacx86.com/threads/guide-intel-framebuffer-patching-using-whatevergreen.256490/) |
| Audio        | Realtek® ALC887-VD2 8-Channel High Definition Audio CODEC | Working | [Guide](https://github.com/acidanthera/AppleALC/wiki/Installation-and-usage)                             |
| Ethernet     |       Realtek® 8111G, 1 x Gigabit LAN Controller(s)       | Working | -                                                                                                        |
| Keyboard     |                             -                             | Working | -                                                                                                        |
| LAN          |       Realtek® 8111G, 1 x Gigabit LAN Controller(s)       | Working | -                                                                                                        |

## Extensions 🔨

| Type                                                                                                                    |                                                            Spec                                                             | Status  |
| ----------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------: | ------- |
| [USB WiFi Adaptor](https://www.aliexpress.com/item/33059242651.html)                                                    |                      802.11AC NIC Realtek USB Adaptor Dual Band: Alternative 11AC(5.8G) and 11N(2.4G)                       | Working |
| [WiFi Card M.2 Card](https://www.aliexpress.com/item/4000329990755.html?spm=a2g0s.9042311.0.0.2cb24c4dnm2Qqt)           | BCM94360CS2 Wireless WIFI Bluetooth 4.0 Airport Card For Macbook Air 11" A1465 13" A1466 2013 MD711LL/A MD760 BCM94360CS2AX | Working |
| [NGFF M2 to PCIE AC Converter](https://www.aliexpress.com/item/4001028183672.html?spm=a2g0s.9042311.0.0.35844c4doSjGdi) |                        WTXUP NGFF M2 to PCIE AC Converter Adapter Card AX200 9260 8265 1650A for PC                         | Working |
| Graphics Card                                                                                                           |                                                     NITRO+ RX 580 8G G5                                                     | Working |

## Important Note

### Intel HD4400 Graphics [Not supported on macOS Ventura]

If you want to upgrade to macOS Ventura please disable intel hd 4400 from bios and use compatible graphics card.
If you want to enable HD4400 Please enable
Kernel -> Add -> Enable -> `WhateverGreen.kext`

DeviceProperty -> Add `PciRoot(0x0)/Pci(0x2,0x0)` or Remove comment `#PciRoot(0x0)/Pci(0x2,0x0)`

### Network Card (DW1820A)

If you want to enable DW1820A Please enable

Kernel -> Add -> Enable -> `AirportBrcmFixup.kext`
Kernel -> Add -> Enable -> `AirportBrcmFixup.kext/Contents/PlugIns/AirPortBrcm4360_Injector.kext`
Kernel -> Add -> Enable -> `AirportBrcmFixup.kext/Contents/PlugIns/AirPortBrcmNIC_Injector.kext`
Kernel -> Add -> Enable -> `BrcmBluetoothInjector.kext`
Kernel -> Add -> Enable -> `BrcmFirmwareData.kext`
Kernel -> Add -> Enable -> `BrcmPatchRAM3.kext`

DeviceProperty -> Add `PciRoot(0x0)/Pci(0x1C,0x1)/Pci(0x0,0x0)` or Remove comment `#PciRoot(0x0)/Pci(0x1C,0x1)/Pci(0x0,0x0)`

### USB WiFi Adaptor

Kernel -> Add -> Enable -> `RtWlanDisk.kext`
Kernel -> Add -> Enable -> `RtWlanU.kext`
Kernel -> Add -> Enable -> `RtWlanU1827.kext`

## Software Status 👨‍💻

| Type            | Spec | Status  |
| --------------- | :--: | ------- |
| Sleep/Hibernate |  -   | Unknown |
| iMessage        |  -   | Unknown |

### Kext Used

| Kext                | Info                                                                                                                                                                                  |
| ------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Lilu.kext           | Arbitrary kext and process patching on macOS                                                                                                                                          |
| RestrictEvents.kext | Lilu Kernel extension for blocking unwanted processes causing compatibility issues on different hardware and unlocking the support for certain features restricted to other hardware. |
| VirtualSMC.kext     | SMC Emulator Layer                                                                                                                                                                    |
| SMCProcessor.kext   | Processor Temp Monitoring                                                                                                                                                             |
| SMCSuperIO.kext     | Fan Reading                                                                                                                                                                           |
| WhateverGreen.kext  | Various patches necessary for certain ATI/AMD/Intel/Nvidia GPUs                                                                                                                       |
| AppleALC.kext       | For Audio                                                                                                                                                                             |
| FeatureUnlock.kext  | Add Sidecar support to unsupported models                                                                                                                                             |
| RealtekRTL8111.kext | OS X open source driver for the Realtek RTL8111/8168 family                                                                                                                           |
| HoRNDIS.kext        | macOS USB mapping                                                                                                                                                                     |
| USBToolBox.kext     | macOS USB mapping                                                                                                                                                                     |
| RtWlanU.kext        | USB WiFi Adaptor                                                                                                                                                                      |
| RtWlanU1827.kext    | USB WiFi Adaptor                                                                                                                                                                      |

### SSDT Used

| SSDT                                                                                                                                | Info                             |
| :---------------------------------------------------------------------------------------------------------------------------------- | :------------------------------- |
| [SSDT-EC.aml](https://dortania.github.io/Getting-Started-With-ACPI/Universal/ec-methods/prebuilt.html#wrapping-up)                  | For Broadwell desktops and older |
| [SSDT-PLUG.aml](https://dortania.github.io/Getting-Started-With-ACPI/ssdt-methods/ssdt-prebuilt.html#desktop-haswell-and-broadwell) | For Broadwell desktops and older |

## TODO 😓

| Type                                      | Status |
| ----------------------------------------- | :----- |
| Power Management                          | Done   |
| Sleep/Hibernate                           | NA     |
| Buy compatible WiFi Card                  | Done   |
| Buy RX 580 or RX 570                      | Done   |
| Check LAN Working or Not                  | Done   |
| HDMI Audio Not Working when using HD 4400 | NA     |
| USB mapping tutorial                      | Done   |
| OpenCore Guide                            | NA     |

### Telegram Channel

- [Hackintosh Community Group](https://t.me/indianhackintosh)
- [Hackintosh Channel](https://t.me/hackintoshcommunity)

### Credits

- [Apple](https://www.apple.com) for macOS.
- [Acidanthera](https://github.com/acidanthera) for most of the kexts.
- [goodwin](https://github.com/goodwin) for ALCPlugFix.
- [RehabMan](https://github.com/RehabMan) for some patches.
- [Steve Zheng](https://github.com/stevezhengshiqi) for some patches.
- [Sniki](https://github.com/Sniki) for some patches.
- [daliansky](https://github.com/daliansky) for some patches.
- [Moh_Ameen](https://github.com/ameenjuz) for some patches.
- [al3xtjames](https://github.com/al3xtjames) for clover-theme-oss theme.
- [ImmersiveX](https://github.com/ImmersiveX) for clover-theme-minimal-dark theme.
- And anyone else that helped to develop and improve hackintoshing.
