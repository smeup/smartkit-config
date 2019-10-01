#!/bin/bash

# Nr. max di path configurabili
_MAX_NUM_PATHS=9

_TITLE="Configurazione dei path Windows-Linux"
_FILE_CONFIG=$fileconfig

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
        _WIN[$n]=$(whiptail --title "${_TITLE} ($((n+1)) di $_PATH_NUM)" --backtitle "${_TITLE} $((n+1))" --inputbox "Windows:" $(stty size) "${_WIN_LOADED[$n]}" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus = 0 ]; then
                _LIN[$n]=$(whiptail --title "${_TITLE} ($((n+1)) di $_PATH_NUM)" --backtitle "WIN($n)=${_WIN[$n]}" --inputbox "Windows:${_WIN[$n]} \nLinux:" $(stty size) "${_LIN_LOADED[$n]}" 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus != 0 ]; then
                    continue
                fi
        else
            return
        fi
    done
}

function remove_all_paths () {
    #rimuove tutte le righe dei path (che iniziano per "MAPPING_PATH_0"
    stringStartingWith="MAPPING_PATH_0"
    echo "Rimozione righe ${stringStartingWith}"
    sed -i "/^${stringStartingWith}/d" $_FILE_CONFIG
}

function save_paths () {
    remove_all_paths
    # Scrive variabili legate ai path MAPPING_PATH_ su file di configurazione
    suffix=0
    for ((x=0;x<$n;x++))
    do
        ((suffix++))
        echo "WIN($x)=${_WIN[$x]} - LIN($x)=${_LIN[$x]}"
        newPathString="MAPPING_PATH_0$suffix=WIN(${_WIN[$x]}) LIN(${_LIN[$x]})"
        #sed -i "a$newPathString" $_FILE_CONFIG
    done
}

# MAIN
if [ ! -f "$_FILE_CONFIG" ]; then
    whiptail --title "Attenzione" --msgbox "File configurazione non trovato, esequire prima 'Configurazioni di base'" $(stty size)
    return
fi

# Chiede all'utente numero di coppie (WIN/LIN) di path da gestire (previste max 9 coppie)
while true
do
    _PATH_NUM=$(whiptail --title "${_TITLE}" --inputbox "Nr. di path da gestire (max ${_MAX_NUM_PATHS}):" $(stty size) "" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ] && [ $_PATH_NUM -gt $_MAX_NUM_PATHS ]; then
        whiptail --title "Attenzione" --msgbox "Previste al massimo ${_MAX_NUM_PATHS} coppie (WIN/LIN) di path di configurazione" $(stty size)
        continue
    fi
    if [ $exitstatus = 0 ] && [ $_PATH_NUM -gt 0 ]; then
        paths_configuration
        if [ $n -gt 0 ]; then
            if (whiptail --title "${_TITLE}" --yesno "Salvare i ${n} paths configurati?" $(stty size)); then
                save_paths
            fi
            return
        fi
        return
    else
        return
    fi
done
