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
row=0
while IFS= read -r line
do
    row=$[$row+1]
    list="${list} ${line} \n" 
    if [ ${row} -eq 18 ]; then
        list="${list}                                < PAG. GIÙ PER ALTRI DATI >" 
    fi 
done < "$_FILE_CONFIG"

whiptail --title "${_FILE_CONFIG}" --msgbox --scrolltext "${list}" $_BOX_H $_BOX_W

