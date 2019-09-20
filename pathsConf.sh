#!/bin/bash
function paths_configuration () {

    # TODO 
    # Caricare percorsi esistenti da file di configurazione
    _WIN_LOADED[0]="Percorso Windows 1"
    _LIN_LOADED[0]="Percorso Linux 1"
    _WIN_LOADED[1]="Percorso Windows 2"
    _LIN_LOADED[1]="Percorso Linux 2"
    _WIN_LOADED[2]="Percorso Windows 3"
    _LIN_LOADED[2]="Percorso Linux 3"

    # Crea variabili _WINnn _LINnn
    for ((n=0;n<$_PATH_NUM;n++))
    do
        _WIN[$n]=""
        _LIN[$n]=""
        
        # Remapping windows/linux path WINnn-LINnn
        _WIN[$n]=$(whiptail --title "${_TITLE} ($n di $_PATH_NUM)" --backtitle "${_TITLE} ($n)" --inputbox "Windows:" $_BOX_H $_BOX_W "${_WIN_LOADED[$n]}" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus = 0 ]; then
                _LIN[$n]=$(whiptail --title "${_TITLE} ($n di $_PATH_NUM)" --backtitle "WIN($n)=${_WIN[$n]}" --inputbox "Windows:${_WIN[$n]} \nLinux:" $_BOX_H $_BOX_W "${_LIN_LOADED[$n]}" 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus != 0 ]; then
                    continue
                fi
        else
            return return
        fi
    done
}

# Dimensione dialog
_BOX_H=10
_BOX_W=80
_TITLE="Configurazione dei path Windows-Linux"

# Richiede numero di coppie (WIN/LIN) di path da gestire
_PATH_NUM=$(whiptail --title "${_TITLE}" --inputbox "Nr. di path da gestire:" $_BOX_H $_BOX_W "" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ] && [ $_PATH_NUM -gt 0 ]; then
    paths_configuration

    echo "Configurati ${n} paths:"
    for ((x=0;x<$n;x++))
    do
        echo "WIN($x)=${_WIN[$x]} - LIN($x)=${_LIN[$x]}"
    done
    
else
    return
fi

