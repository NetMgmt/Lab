#!/bin/bash

MIB_OPTIONS="-M +/home/kenobi/mibs -m ALL"

DEST_HOST=10.0.123.2

set -x
snmptrap $MIB_OPTIONS -d -Ci -v 2c -c public $DEST_HOST \
	"" UAH-AUT-GR-EXAMPLES-NOTIFICATION-MIB::uahAutGrNotifEvBasic \
	SNMPv2-MIB::sysLocation.0 s "GR. The Lab!"
