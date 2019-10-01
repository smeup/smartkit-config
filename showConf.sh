#!/bin/bash

#_FILE_CONFIG="${HOME}/container/smeup-provider-fe/config/smeup-provider-fe/configuration.properties"
_FILE_CONFIG=$fileconfig

# MAIN
if [ ! -f "$_FILE_CONFIG" ]; then
    whiptail --title "Attenzione" --msgbox "File configurazione non trovato, esequire prima 'Configurazioni di base'" $(stty size)
    return
fi


whiptail --textbox --scrolltext --title "PgDn/Up per scorrere il testo" "${_FILE_CONFIG}" $(stty size)

