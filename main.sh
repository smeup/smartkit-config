#!/bin/bash

while true
do
    menuChoose=$(whiptail --title "Menu configurazione" --menu "Configurazione:" 25 78 16 \
    "Configurazione" "Visualizza configurazione" \
    "Base" "Imposta configurazione di base" \
    "Paths" "Imposta mapping Windows/Linux" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ "$exitstatus" = 0 ]; then
        if [ "$menuChoose" = "Configurazione" ]; then
            source showConf.sh
        elif [ "$menuChoose" = "Base" ]; then
            source smartkitconf.sh
        elif [ "$menuChoose" = "Paths" ]; then
            source pathsConf.sh
        fi
    else
        break
    fi

done