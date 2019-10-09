#!/bin/bash

_TITLE="Conferma operazione richiesta"

if (whiptail --title "${_TITLE}" --yesno --defaultno "Sei sicuro di voler aggiornare il Provider ?" 10 40) then
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        update-provider
    else
        return
    fi
    
fi
