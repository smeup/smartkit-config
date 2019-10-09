#!/bin/bash

fileconfig="${HOME}/container/smeup-provider-fe/config/smeup-provider-fe/configuration.properties"

while true
do
    menuChoose=$(whiptail --title "Menu configurazione" --menu "Configurazione:" $(stty size) 16 \
    "Configurazione" "Visualizza configurazione" \
    "Base" "Imposta configurazione di base" \
    "Paths" "Imposta mapping Windows/Linux" \
    "RestartDocker" "Riavvia Provider FE" \
    "Riavvio" "Riavvia Smart Kit" \
    "Zip" "Crea zip dei log" \
    "Aggiorna" "Aggiorna Provider FE" 3>&1 1>&2 2>&3)


    exitstatus=$?
    if [ "$exitstatus" = 0 ]; then
        if [ "$menuChoose" = "Configurazione" ]; then
            source showConf.sh
        elif [ "$menuChoose" = "Base" ]; then
            source smartkitConf.sh
        elif [ "$menuChoose" = "Paths" ]; then
            source pathsConf.sh
        elif [ "$menuChoose" = "RestartDocker" ]; then
            source smartkitRestart.sh
        elif [ "$menuChoose" = "Riavvio" ]; then
            source smartkitReboot.sh
        elif [ "$menuChoose" = "Zip" ]; then
	    source smartkitMakeZip.sh
        elif [ "$menuChoose" = "Aggiorna" ]; then
            source smartkitUpdate.sh
        fi
    else
        break
    fi

done
