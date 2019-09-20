#!/bin/bash

# Dimensione dialog
_BOX_H=25
_BOX_W=100

_FILE_CONFIG="configuration.properties"

# MAIN
if [ ! -f "$_FILE_CONFIG" ]; then
    whiptail --title "Attenzione" --msgbox "File configurazione non trovato, esequire prima 'Configurazioni di base'" $_BOX_H $_BOX_W
    return
fi

# Legge file di configurazione
while IFS= read -r line
do
    list="$list$line \n"  
done < "$_FILE_CONFIG"

whiptail --title "${_FILE_CONFIG}" --msgbox --scrolltext --defaultno "${list}" $_BOX_H $_BOX_W

