#!/bin/bash

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

fileconfig="configuration.properties"
filetemplate="configuration.properties.template"

file=$fileconfig

if [ -f "$file" ]
then
    echo "$file found."
else
    file=$filetemplate
    if [ -f "$file" ]
    then
        echo "$file found."
    else
        echo "$file not found."
        exit
    fi
fi

while IFS='=' read -r key value
do
    case $key in
    user | password | server | serverQName | env)
        ### TODO: togliere echo una volta terminata la fase di test 
        echo $key
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

### TODO: togliere echo una volta terminata la fase di test 
echo "_D_SME1 $_D_SME1"
echo "_D_SME2 $_D_SME2"
echo ${scpkey[*]}
echo ${scpval[*]}
echo ${resval[*]}
echo ${defval[*]}
echo ${atitle[*]}
echo ${alabel[*]}

V=0
### TODO: togliere echo una volta terminata la fase di test 
echo $V
while [ $V -le $[$MX+1] ]; do
    ### TODO: togliere echo una volta terminata la fase di test 
    echo $V
    if [ $V -eq 0 ]; then   
        ### TODO: togliere echo una volta terminata la fase di test 
        echo 'primo'
        ## per ogni variabile testo che il valore sia stato impostato;
        ## in caso contrario ciclo e riemetto la richiesta.
        ## se l'utente preme 'cancel' esco
        ### per prima cosa scelgo se lo smart kit ha una configurazione Sme.UP o NON Sme.UP
        until [ ! -z ${resval[$V]} ]; do
            resval[$V]=$(whiptail --title "${V} - ${atitle[$V]}" --radiolist \
            "${alabel[$V]}" 10 60 2 \
            "1" "Sme.UP" ${_D_SME1} \
            "2" "NON Sme.UP" ${_D_SME2}  3>&1 1>&2 2>&3)
            exitstatus=$?
            if [ $exitstatus != 0 ]; then
                exit
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
        riepilogo=' '
        X=0
        while [ $X -le $MX ] 
        do
            riepilogo="${riepilogo} ${atitle[$X]} : ${resval[$X]} ${dscval[$X]} \n "
            X=$[$X+1]
        done
        ## riepilogo i parametri impostati e chiedo conferma
        whiptail --title "Conferma configurazione" --yesno --scrolltext --defaultno "${riepilogo}"  20 80

        exitstatus=$?
        ## copio il template e scrivo i parametri solo se l'utente ha confermato
        if [ $exitstatus = 0 ]; then
            cp -n $filetemplate $fileconfig
            if [ ${resval[0]} = '1' ]; then
            ## l'ambiente va impostato solo se Smart kit 'Sme.UP'
                sed -i "s/#env=/env=/" $fileconfig
            else
            ## la riga con env= va commentata
                sed -i "s/env=/#env=/" $fileconfig
            fi
            ### TODO: togliere echo una volta terminata la fase di test 
            echo ${scpkey[*]}
            echo ${scpval[*]}
            echo ${resval[*]}
            X=1
            while [ $X -le $MX ] 
            do
                ### TODO: togliere echo una volta terminata la fase di test 
                echo "s/${scpkey[$X]}=${scpval[$X]}/${scpkey[$X]}=${resval[$X]}/"
                sed -i "s/${scpkey[$X]}=${scpval[$X]}/${scpkey[$X]}=${resval[$X]}/" $fileconfig
                X=$[$X+1]
            done

            ### TODO: visualizzazione del file di properties da togliere una volta terminata la fase di test
            less $fileconfig
        fi
        exit
    else
        ### TODO: togliere echo una volta terminata la fase di test 
        echo "pre domanda"
        echo $V
        if  [ ${scpkey[$V]} = 'env' ] && [ ${resval[0]} = '2' ]; then
                resval[$V]=''
                V=$[$V+1]
                ### TODO: togliere echo una volta terminata la fase di test 
                echo $V
        else
            ## per ogni variabile testo che il valore sia stato impostato;
            ## in caso contrario ciclo e riemetto la richiesta.
            ## se l'utente preme 'cancel' torno indietro alla domanda precedente
            until [ ! -z ${resval[$V]} ]; do
                resval[$V]=$(whiptail --title "${V} - ${atitle[$V]}" --cancel-button "indietro" --inputbox "${alabel[$V]}" 10 60 "${defval[$V]}" 3>&1 1>&2 2>&3)
                exitstatus=$?
                ### TODO: togliere echo una volta terminata la fase di test 
                echo $exitstatus
                echo ${resval[$V]}
                if [ $exitstatus != 0 ]; then
                    V=$[$V-1]
                    if  [ $V -ge 0 ]; then
                        eval resval[$V]=''
                    fi
                    ### TODO: togliere echo una volta terminata la fase di test 
                    echo $V
                    echo "break"
                    break
               elif [ ! -z ${resval[$V]} ]; then
                    eval defval[$V]=${resval[$V]}
                    V=$[$V+1]
                    break
                fi
            done
            ### TODO: togliere echo una volta terminata la fase di test 
            echo "post domanda"
            echo $V
        fi
    fi
done
