#!/bin/bash

# Dimensione dialog
_BOX_H=10
_BOX_W=80

# Nr. max di path configurabili
_MAX_NUM_PATHS=9

_TITLE="Configurazione dei path Windows-Linux"
_FILE_CONFIG="configuration.properties"

# Funzione caricamento in memoria dei valori dei path (legge da file di configurazione)
function load_paths (){
    configuredPaths=0
    while IFS= read -r line
        do
        echo "$line"
        if [[ ${line} == *"MAPPING_PATH_0"* ]] && [[ ${configuredPaths} -le ${_MAX_NUM_PATHS} ]]; then
            _WIN_LOADED[configuredPaths]=$(grep -oP '(?<=WIN\().*?(?=\))' <<< "$line")
            _LIN_LOADED[configuredPaths]=$(grep -oP '(?<=LIN\().*?(?=\))' <<< "$line")
            configuredPaths=$((configuredPaths + 1))
        fi

    done < "$_FILE_CONFIG"
}

function paths_configuration () {
    # Carica percorsi esistenti da file di configurazione
    load_paths

    # Crea variabili _WINnn _LINnn con valori digitati dall'utente
    for ((n=0;n<$_PATH_NUM;n++))
    do
        _WIN[$n]=""
        _LIN[$n]=""
        # Remapping windows/linux path WINnn-LINnn
        _WIN[$n]=$(whiptail --title "${_TITLE} ($((n+1)) di $_PATH_NUM)" --backtitle "${_TITLE} $((n+1))" --inputbox "Windows:" $_BOX_H $_BOX_W "${_WIN_LOADED[$n]}" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus = 0 ]; then
                _LIN[$n]=$(whiptail --title "${_TITLE} ($((n+1)) di $_PATH_NUM)" --backtitle "WIN($n)=${_WIN[$n]}" --inputbox "Windows:${_WIN[$n]} \nLinux:" $_BOX_H $_BOX_W "${_LIN_LOADED[$n]}" 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus != 0 ]; then
                    continue
                fi
        else
            return return
        fi
    done
}

# MAIN
if [ ! -f "$_FILE_CONFIG" ]; then
    whiptail --title "Attenzione" --msgbox "File configurazione non trovato, esequire prima 'Configurazioni di base'" $_BOX_H $_BOX_W
    return
fi

# Chiede all'utente numero di coppie (WIN/LIN) di path da gestire (previste max 9 coppie)
_PATH_NUM=$(whiptail --title "${_TITLE}" --inputbox "Nr. di path da gestire (max ${_MAX_NUM_PATHS}):" $_BOX_H $_BOX_W "" 3>&1 1>&2 2>&3)
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
