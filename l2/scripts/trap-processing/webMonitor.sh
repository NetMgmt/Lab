#!/bin/bash
WEB_LIST=(1.1.1.1 2.2.2.2)

while true
do
    for WEB in "${WEB_LIST[@]}"
    do
        if wget -q --tries=1 --timeout=3 --spider $WEB
        then
            echo .Acceso OK a $WEB
            # --- enviar aquí el trap ----
        else
            echo .Acceso ERROR a $WEB
            # --- enviar aquí el trap ---
        fi

        sleep 10
    done
done
