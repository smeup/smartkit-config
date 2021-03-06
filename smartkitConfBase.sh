﻿#!/bin/bash

###########################################################
#
# Script per la configurazione dei parametri del Provider
#
###########################################################

# dichiaro gli array con 5 elementi
MX=5
# nome del parametro
scpkey=(zero one two three four five)
# valore del parametro nello script di configurazione
scpval=(zero one two three four five)
# valore della risposta
resval=(zero one two three four five)
# descrizione valore
dscval=(zero one two three four five)
# valore proposto alla domanda
defval=(zero one two three four five)
# titolo
atitle=(zero one two three four five)
# testo
alabel=(zero one two three four five)

function checkfield() {
## controlli specifici per campo
lenvar=${#fldval}

if [ ${lenvar} -ne 6 ] && [ ${fldnam} = 'serverQName' ]; then
    whiptail --msgbox "Il nome della coda dati deve essere lungo 6 !" $(stty size)
    eval fldval=''
    return 1
elif [ ${lenvar} -gt 10 ] && [ ${fldnam} = 'env' ]; then
    whiptail --msgbox "Il codice ambiente ha lunghezza massima 10 !" $(stty size)
    eval fldval=''
    return 1
elif [ ${lenvar} -gt 10 ] && [ ${fldnam} = 'user' ]; then
    whiptail --msgbox "Il nome utente ha lunghezza massima 10 !" $(stty size)
    eval fldval=''
    return 1
elif  [ ${fldnam} = 'server' ]; then
    checkip
    if [ $? -ne 0 ]; then
        whiptail --msgbox "Indirizzo del server non valido." $(stty size)
        eval fldval=''
        return 1
    else
        return 0
    fi
else
    return 0
fi
}

function checkip() 
{
    local ip=$fldval
    local stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    else
        stat=0
    fi

    # Not used cause "host" software is not installed into VM
    #if [ $stat -ne 0 ]; then
    #    get_ip
    #    stat=$?
    #fi

    return $stat
}

# Not used cause "host" software is not installed into VM
function get_ip {

    local ip_address=''
    local hostname=$fldval

    # query A record for IPv4  by default, use AAAA for IPv6
    local query_type="A"

    # check
    host -t ${query_type}  ${hostname} &>/dev/null
    if [ "$?" -eq "0" ]; then
        # get
        ip_address="$(host -t ${query_type} ${hostname} | awk '/has.*address/ {print $NF; exit}')"
        return 0
    else
        return 1
    fi
}

X=0
while [ $X -le $MX ] 
do
    scpkey[$X]=''
    scpval[$X]=''
    resval[$X]=''
    defval[$X]=''
    dscval[$X]=''
    atitle[$X]=''
    alabel[$X]=''
    X=$[$X+1]
done
X=0
scpkey[$X]='SmarkitType'
atitle[$X]='Tipo Smartkit'
alabel[$X]='Tipo Smartkit'
X=1
scpkey[$X]='user'
atitle[$X]='Utente IBM i'
alabel[$X]='Utente IBM i'
X=2 
scpkey[$X]='password'
atitle[$X]='Password'
alabel[$X]='Password'   
X=3  
scpkey[$X]='server'
atitle[$X]='Indirizzo IBM i'
alabel[$X]='Indirizzo IBM i'   
X=4
scpkey[$X]='serverQName'
atitle[$X]='Coda dati'
alabel[$X]='Coda dati'
defval[$X]='PRVKIT'   
X=5 
scpkey[$X]='env'
atitle[$X]='Ambiente Sme.UP'
alabel[$X]='Ambiente Sme.UP'

# fileconfig="${HOME}/container/smeup-provider-fe/config/smeup-provider-fe/configuration.properties"

file=$fileconfig

if [ -f "$file" ]
then
    echo "$file found."
else
    whiptail --msgbox "$file not found." $(stty size)
    exit
fi

while IFS='=' read -r key value
do
    case $key in
    user | password | server | serverQName | env)
        X=0
        while [ $X -le $MX ] 
        do
            if  [ ${scpkey[$X]} = ${key} ]; then
               scpval[$X]=${value}
               break
            fi
            X=$[$X+1]
        done
    esac
done < "$file"

if  [ $file = $fileconfig ]; then
    X=0
    while [ $X -le $MX ] 
    do
        defval[$X]=${scpval[$X]}
        if  [ ${scpkey[$X]} = 'env' ]; then
            if  [ ! -z ${scpval[$X]} ]; then
                eval _D_SME1=ON
                eval _D_SME2=OFF
            else
                eval _D_SME1=OFF
                eval _D_SME2=ON
            fi
        fi
        X=$[$X+1]
    done
else
# per una nuova configurazione parto senza tipo impostato
    eval _D_SME1=OFF
    eval _D_SME2=OFF
fi

V=0
### TODO: togliere echo una volta terminata la fase di test 
echo $V
while [ $V -le $[$MX+1] ]; do
    if [ $V -eq 0 ]; then   
        ## Qui entra al primo giro per chiedere se SmeUP o NON SmeUP
        ## per ogni variabile testo che il valore sia stato impostato;
        ## in caso contrario ciclo e riemetto la richiesta.
        ## se l'utente preme 'cancel' esco
        ### per prima cosa scelgo se lo smart kit ha una configurazione Sme.UP o NON Sme.UP
        until [ ! -z ${resval[$V]} ]; do
            resval[$V]=$(whiptail --title "${V} - ${atitle[$V]}" --radiolist \
            "${alabel[$V]}" $(stty size) 2 \
            "1" "Sme.UP" ${_D_SME1} \
            "2" "NON Sme.UP" ${_D_SME2}  3>&1 1>&2 2>&3)
            exitstatus=$?
            if [ $exitstatus != 0 ]; then
                return
            else
                if  [ ${resval[$V]} = '1' ]; then
                    eval _D_SME1=ON
                    eval _D_SME2=OFF
                    dscval[$V]="Sme.UP"
                elif [ ${resval[$V]} = '2' ]; then
                    eval _D_SME1=OFF
                    eval _D_SME2=ON
                    dscval[$V]="NON Sme.UP"
                fi
            fi
        done
        V=1
    elif [ $V -eq $[$MX+1] ]; then
        ## Qui entra alla fine (dopo che ho fatto tutte le domande) per riepilogare e scrivere il file proprieties
        riepilogo=' '
        X=0
        while [ $X -le $MX ] 
        do
            riepilogo="${riepilogo} ${atitle[$X]} : ${resval[$X]} ${dscval[$X]} \n "
            X=$[$X+1]
        done
        ## riepilogo i parametri impostati e chiedo conferma
        whiptail --title "Conferma configurazione" --yesno --scrolltext --defaultno "${riepilogo}"  $(stty size)

        exitstatus=$?
        ## scrivo i parametri solo se l'utente ha confermato
        if [ $exitstatus = 0 ]; then
            time=$(date +%Y-%m-%d_%H-%M-%S)
            backupFileConfig="${time}_configuration.properties"
            cp ${fileconfig} ${backupFolder}/${backupFileConfig}
            if [ ${resval[0]} = '1' ]; then
            ## l'ambiente va impostato solo se Smart kit 'Sme.UP'
                sed -i "s/#env=/env=/" $fileconfig
            else
                ## Siamo nel caso di NON-SMEUP
                ## la riga con env= va commentata
                sed -i "s/env=/#env=/" $fileconfig

                ## La riga con xmlini va decommentata e impostata su DEFAULT
                ## per prendere xml di default
                sed -i "/#xmlini=.*/a xmlini=DEFAULT" $fileconfig

                ## Il ping deve essere disattivato
                ## Lasciati entrambi per mantenere conpatibilità
                sed -i "s/pingPeriod=100/#pingPeriod=100/" $fileconfig
                sed -i "s/#pingPeriod=-1/pingPeriod=-1/" $fileconfig
            fi
            X=1
            while [ $X -le $MX ] 
            do
                sed -i "s/${scpkey[$X]}=${scpval[$X]}/${scpkey[$X]}=${resval[$X]}/" $fileconfig
                X=$[$X+1]
            done
            if [ ${resval[0]} = '1' ]; then
            ## se Smart kit 'Sme.UP' tolgo righe env vuote
                sed -i "s/^env=$//" $fileconfig
            fi

            # Legge file di configurazione per emissione a video riepilogo
            source showConf.sh
        fi
        return
    else
        ## Qui passa chiedendo le domande dalla 2a all'ultima compresa
        if  [ ${scpkey[$V]} = 'env' ] && [ ${resval[0]} = '2' ]; then
                resval[$V]=''
                V=$[$V+1]
        else
            ## per ogni variabile testo che il valore sia stato impostato;
            ## in caso contrario ciclo e riemetto la richiesta.
            ## se l'utente preme 'cancel' torno indietro alla domanda precedente
            until [ ! -z ${resval[$V]} ]; do
                defValToTrim=${defval[$V]}
                defValTrimmed=`echo $defValToTrim`
                resval[$V]=$(whiptail --title "${V} - ${atitle[$V]}" --cancel-button "indietro" --inputbox "${alabel[$V]}" $(stty size) "${defValTrimmed}" 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus != 0 ]; then
                    V=$[$V-1]
                    if  [ $V -ge 0 ]; then
                        eval resval[$V]=''
                    fi
                    break
                elif [ ! -z ${resval[$V]} ]; then
                    fldval=${resval[$V]}
                    fldnam=${scpkey[$V]}
                    checkfield
                    if [ $? -ne 0 ]; then
                        eval resval[$V]=''
                    else
                        eval defval[$V]=${fldval}
                        V=$[$V+1]
                        break
                    fi
                fi
            done
        fi
    fi
done
