#!/bin/bash

###########################################################
#
# Script per la configurazione dei parametri del Provider
#
###########################################################

## per ogni variabile testo che il valore sia stato impostato;
## in caso contrario ciclo e riemetto la richiesta.
## se l'utente preme 'cancel' esco

### per prima cosa scelgo se lo smart kit ha una configurazione Sme.UP o NON Sme.UP
until [ ! -z $_SME ]; do
    _SME=$(whiptail --title "Configurazione Smart kit" --radiolist \
    "Tipo Smart kit" 10 60 2 \
    "1" "Sme.UP" OFF \
    "2" "NON Sme.UP" OFF  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        exit
    fi
done
until [ ! -z $_USER ]; do
    _USER=$(whiptail --title "Configurazione Smart kit" --inputbox "Utente IBM i per collegamento" 10 60  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        exit
    fi
done
until [ ! -z $_PWD ]; do
    _PWD=$(whiptail --title "Configurazione Smart kit" --inputbox "Password" 10 60  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        exit
    fi
done
until [ ! -z $_ADDRESS ]; do
    _ADDRESS=$(whiptail --title "Configurazione Smart kit" --inputbox "Indirizzo IBM i" 10 60  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        exit
    fi
done
until [ ! -z $_DTAQ ]; do
    _DTAQ=$(whiptail --title "Configurazione Smart kit" --inputbox "Coda dati" 10 60 PRVKIT 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        exit
    fi
done
## l'ambiente va impostato solo se Smart kit 'Sme.UP'
if [ $_SME = 1 ]; then
    until [ ! -z $_ENV ]; do
        _ENV=$(whiptail --title "Configurazione Smart kit" --inputbox "Ambiente" 10 60  3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus != 0 ]; then
            exit
        fi
    done
    _DESSK="Sme.UP"
else
    _DESSK="NON Sme.UP"
fi

## riepilogo i parametri impostati e chiedo conferma
if [ $_SME = 1 ]; then
    whiptail --title "Conferma configurazione" --yesno --scrolltext --defaultno " Tipo Smart kit: $_DESSK \n Utente: $_USER \n Password: $_PWD \n Indirizzo IBM i: $_ADDRESS \n Coda dati: $_DTAQ \n Ambiente: $_ENV "  20 80
else
    whiptail --title "Conferma configurazione" --yesno --scrolltext --defaultno " Tipo Smart kit: $_DESSK \n Utente: $_USER \n Password: $_PWD \n Indirizzo IBM i: $_ADDRESS \n Coda dati: $_DTAQ "  20 80
fi

exitstatus=$?
## copio il template e scrivo i parametri solo se l'utente ha confermato
if [ $exitstatus = 0 ]; then
    cp configuration.properties.template configuration.properties

    sed -i "s/UTENTE/${_USER}/" configuration.properties
    sed -i "s/PASSWORD/${_PWD}/" configuration.properties
    sed -i "s/INDIRIZZO/${_ADDRESS}/" configuration.properties
    sed -i "s/CODICE-PROVIDER/${_DTAQ}/" configuration.properties
    if [ $_SME = 1 ]; then
    ## l'ambiente va impostato solo se Smart kit 'Sme.UP'
        sed -i "s/AMBIENTE/${_ENV}/" configuration.properties
    else
    ## la riga con env= va commentata
        sed -i "s/env=/#env=/" configuration.properties
    fi
else
    exit
fi

### TODO: visualizzazione del file di properties da togliere una volta terminata la fase di test
less configuration.properties
