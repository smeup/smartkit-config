#!/bin/bash

_TITLE="Conferma operazione richiesta"

if (whiptail --title "${_TITLE}" --yesno --defaultno "Sei sicuro di voler riavviare il Provider ?" 10 40) then
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
	_RESULT=$(docker restart smeup-provider-fe 2>&1)
        exitcode=$?
        if [ $exitcode = 0 ]; then
            whiptail --title "{$_TITLE}" --msgbox --scrolltext "$_RESULT riavviato correttamente. Devi premere OK per continuare." 10  80
        else
            whiptail --title "{$_TITLE}" --msgbox --scrolltext "$_RESULT\n\nRiavvio NON eseguito. Devi premere OK per continuare." 40  80
        fi
    else
        return
    fi
fi
