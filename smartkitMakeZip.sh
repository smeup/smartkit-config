#!/bin/bash

_TITLE="Conferma operazione richiesta"
_DIR=/home/smeup/container/smeup-provider-fe/log
_LOG=$_DIR/`date +%Y%m%d%H%M%S`_logs.tar.gz

if (whiptail --title "${_TITLE}" --yesno --defaultno "Sei sicuro di voler creare lo zip dei logs ?" 10 40) then
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
	touch $_LOG
        _RESULT=$(tar --exclude=*_logs.tar.gz -czvf $_LOG -C $_DIR . 2>&1)
        exitcode=$?
    	if [ $exitcode = 0 ]; then
	    whiptail --title "{$_TITLE}" --msgbox --scrolltext "Archivio $_LOG creato correttamente. Devi premere OK per continuare." 10  80
	else
	    whiptail --title "{$_TITLE}" --msgbox --scrolltext "$_RESULT\n\nArchivio $_LOG NON creato correttamente. Devi premere OK per continuare." 40  80
	fi
    else
        return 
    fi
fi
