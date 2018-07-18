#!/bin/bash

HEX=`readlink -f keyboard_left.hex`
du -b $HEX

echo
echo '============================= PROGRAMMING ============================='
{
	echo "reset halt";
	sleep 0.1;
	echo "flash write_image erase" $HEX;
	sleep 4;
	echo "reset";
	sleep 0.1;
	exit;

} | telnet localhost 4444

echo
echo '============================== FINISHED ==============================='
