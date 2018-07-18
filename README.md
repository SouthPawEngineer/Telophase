# Telophase Keyboard Firmware
Firmware for Nordic MCUs used in the Telophase Keyboard, containing the necessary hex files.
This firmware is a dervivative of reversebias' mitosis firmware.
https://github.com/reversebias/mitosis

These instructions are for flashing hex files to the boards via OpenOCD using an ST-Link programmer. This process has been tested on Windows 10 and Linux. Alternatively, one could use NRF Studio Go and a J-Link/J-Link EDU, or the nrfjprog utility.
On the Telophase/Meiosis/Helicase/Centromere, there is a 4-pin 2.54mm header that one can program the boards by either soldering a right angle header or using a pogo pin adapter without soldering.
## OpenOCD server
The programming header on the side of the keyboard, VCC (3.3V) is at the outside edge:
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
From the factory, these chips need to be erased. Now open a new terminal window in the folder with your hex files and run the following commands:
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

## Programming via scripts
There are scripts in the hex file directory to flash the boards. Open a terminal window and start OpenOCD as above. Open a second terminal window, and run the appropriate script for your receiver type, or the half of the keyboard you are flashing:
```
./program-keyboard-receiver.sh
```
