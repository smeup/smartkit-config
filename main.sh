#!/bin/bash

while true
do
    menuChoose=$(whiptail --title "Menu configurazione" --menu "Configurazione:" 25 78 16 \
    "Configurazione" "Visualizza configurazione" \
    "Base" "Imposta configurazione di base" \
    "Paths" "Imposta mapping Windows/Linux" \
    "Riavvio" "Riavvia" \
    "Zip" "Crea zip dei log" \
    "Aggiorna" "Aggiorna provider" 3>&1 1>&2 2>&3)


    exitstatus=$?
    if [ "$exitstatus" = 0 ]; then
        if [ "$menuChoose" = "Configurazione" ]; then
            source showConf.sh
        elif [ "$menuChoose" = "Base" ]; then
            source smartkitConf.sh
        elif [ "$menuChoose" = "Paths" ]; then
            source pathsConf.sh
        elif [ "$menuChoose" = "Riavvio" ]; then
            echo "not implemented yet"
        elif [ "$menuChoose" = "Zip" ]; then
            echo "not implemented yet"
        elif [ "$menuChoose" = "Aggiorna" ]; then
            echo "not implemented yet"
        fi
    else
        break
    fi

done