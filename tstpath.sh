#!/bin/bash
function paths_configuration () {

    # Crea variabili _WINnn _LINnn
    for ((n=0;n<$_PATH_NUM;n++))
    do
        _WIN[$n]=""
        _LIN[$n]=""
        
        # Remapping windows/linux path WINnn-LINnn
        _WIN[$n]=$(whiptail --title "Paths configuration ($n)" --backtitle "Paths configuration ($n)" --inputbox "Windows:" $_BOX_H $_BOX_W "" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus = 0 ]; then
            until [ ! -z ${_LIN[$n]} ]; do
                _LIN[$n]=$(whiptail --title "Paths configuration ($n)" --backtitle "WIN($n)=${_WIN[$n]}     " --inputbox "Linux:" $_BOX_H $_BOX_W "" 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus != 0 ]; then
                    exit
                fi
            done
        else
            return exit
        fi
    done
}

# Dimensione dialog
_BOX_H=10
_BOX_W=80

# Richiede numero di coppie (WIN/LIN) di path da gestire
_PATH_NUM=$(whiptail --title "Paths configuration" --inputbox "Nr. di path da gestire:" $_BOX_H $_BOX_W 0 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ] && [ $_PATH_NUM -gt 0 ]; then
    paths_configuration

    echo "Configurati ${n} paths:"
    for ((x=0;x<$n;x++))
    do
        echo "WIN($x)=${_WIN[$x]} - LIN($x)=${_LIN[$x]}"
    done
    
else
    exit
fi

