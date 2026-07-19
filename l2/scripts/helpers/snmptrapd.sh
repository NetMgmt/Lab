#!/bin/bash

MIB_OPTIONS="-M +/home/kenobi/mibs -m ALL"

set -x
snmptrapd $MIB_OPTIONS -f -Lo -C -c /home/kenobi/snmp/snmptrapd.p2.conf
