#!/bin/bash

MIB_OPTIONS="-M +/home/kenobi/mibs -m ALL"

DEST_HOST=10.0.123.2

set -x
snmptrap $MIB_OPTIONS -d -v 1 -c public $DEST_HOST \
	UAH-AUT-GR-EXAMPLES-TRAP-MIB::uahAutGrTraps "" 6 17 "" \
	SNMPv2-MIB::sysLocation.0 s "This Lab!" 
