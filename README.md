# Telophase Keyboard Firmware
Firmware for Nordic MCUs used in the Telophase Keyboard, contains precompiled .hex files, as well as sources buildable with the Nordic SDK
This firmware is a dervivative of reversebias' mitosis firmware.
https://github.com/reversebias/mitosis

## Install dependencies

Tested on Ubuntu 16.04.2, but should be able to find alternatives on all distros.

```
sudo apt install openocd gcc-arm-none-eabi
```

## Download Nordic SDK

Nordic does not allow redistribution of their SDK or components, so download and extract from their site:

https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v11.x.x/nRF5_SDK_11.0.0_89a8197.zip

Firmware written and tested with version 11

```
unzip nRF5_SDK_11.0.0_89a8197.zip  -d nRF5_SDK_11
cd nRF5_SDK_11
```

## Toolchain set-up

A cofiguration file that came with the SDK needs to be changed. Assuming you installed gcc-arm with apt, the compiler root path needs to be changed in /components/toolchain/gcc/Makefile.posix, the line:
```
GNU_INSTALL_ROOT := /usr/local/gcc-arm-none-eabi-4_9-2015q1
```
Replaced with:
```
GNU_INSTALL_ROOT := /usr/
```

## OpenOCD server
The programming header on the side of the keyboard, VCC (3.3V) is at hte outside edge:
```
SWCLK
SWDIO
GND
3.3V
```
It's best to remove the battery during long sessions of debugging, as charging non-rechargeable lithium batteries isn't recommended.

Launch a debugging session within a terminal inside of your working directory where the hex files are located:
```
openocd -f nrf-stlink.cfg
```
Should give you an output ending in:
```
Info : nrf51.cpu: hardware has 4 breakpoints, 2 watchpoints
```
Otherwise you likely have a loose or wrong wire.


## Manual programming
From the factory, these chips need to be erased. Now open a new terminal window and run the following commands:
```
echo reset halt | telnet localhost 4444
echo nrf51 mass_erase | telnet localhost 4444
```
From there, the precompiled binaries can be loaded:
```
echo reset halt | telnet localhost 4444
echo flash write_image `readlink -f keyboard_left.hex` | telnet localhost 4444
echo reset | telnet localhost 4444
```

An openocd session should be running in another terminal, as this script sends commands to it.
