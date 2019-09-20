#!/bin/bash

fileconfig="configuration.properties"

while true
do

    menuChoose=$(whiptail --title "Menu configurazione" --menu "Configurazione:" 25 78 16 \
    "Base" "Configurazioni di base." \
    "Paths" "Percorsi Windows/Linux" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ "$exitstatus" = 0 ]; then
        if [ "$menuChoose" = "Base" ]; then
            source smartkitconf.sh
        elif [ "$menuChoose" = "Paths" ]; then
            echo "scelto Paths"
            if [ -f "$fileconfig" ]; then
                echo "file esiste"
                source pathsConf.sh
            else
                echo "file NON esiste"
                whiptail --title "Attenzione" --msgbox "File configurazione non trovato, esequire prima 'Configurazioni di base'" 8 78
            fi
        fi
    else
        break
    fi

done