#!/bin/bash

#_FILE_CONFIG="${HOME}/container/smeup-provider-fe/config/smeup-provider-fe/configuration.properties"
_FILE_CONFIG=$fileconfig

# MAIN
if [ ! -f "$_FILE_CONFIG" ]; then
    whiptail --title "Attenzione" --msgbox "File configurazione non trovato, esequire prima 'Configurazioni di base'" $(stty size)
    return
fi

<<<<<<< HEAD
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
=======
>>>>>>> fbcd5e35e16988e4e472ebcb46ce1aa8e2f5169c

whiptail --textbox --scrolltext --title "PgDn/Up per scorrere il testo" "${_FILE_CONFIG}" $(stty size)

