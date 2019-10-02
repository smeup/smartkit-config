#!/bin/bash

_TITLE="Conferma operazione richiesta"

if (whiptail --title "${_TITLE}" --yesno --defaultno "Sei sicuro di voler riavviare lo Smart Kit ?" 10 40) then
    PASSWORD=$(whiptail --title "Password amministratore" --passwordbox "Inserisci la password e scegli Ok to per continuare" 10 40 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ] && [ ! -z $PASSWORD ]; then
        echo $PASSWORD | sudo -S reboot
    else
        return
    fi
    
fi