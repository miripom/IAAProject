#!/bin/bash
#exec 1>/dev/null # @echo off
clear # cls
#title "MAS"
SICSTUS_HOME=/Users/mirianapompilio/bin/sp-4.7.1
MAIN_HOME=../..
DALI_HOME=../src
CONF_DIR=conf
PROLOG="/Users/mirianapompilio/bin/sicstus"
WAIT="ping -c 4 127.0.0.1"
BUILD_HOME=build
XTERM=xterm

rm -rf tmp/*
rm -rf build/*
rm -f work/* # remove everything if you want to clear agent history
rm -rf conf/mas/*

cp mas/*.txt work


$XTERM -hold -e "$PROLOG -l $DALI_HOME/active_server_wi.pl --goal \"go(3010,'server.txt').\"" & #start /B "" "%PROLOG%" -l "%DALI_HOME%/active_server_wi.pl" --goal go(3010,'%daliH%/server.txt').
echo Server ready. Starting the MAS....
$WAIT > /dev/null # %WAIT% >nul

$XTERM -hold -e "$PROLOG -l $DALI_HOME/active_user_wi.pl --goal utente." & # start /B "" "%PROLOG%" -l "%DALI_HOME%/active_user_wi.pl" --goal utente.
echo Launching agents instances...
$WAIT > /dev/null # %WAIT% > nul

# Launch agents
for agent_filename in mas/*.txt
do
	agent_base="${agent_filename##*/}"
    echo "Agente: $agent_base"
    $XTERM -e "./conf/makeconf.sh $agent_base $DALI_HOME" &
    $XTERM -T "$agent_base" -hold -e "./conf/startagent.sh $agent_base $PROLOG $DALI_HOME" &
    sleep 2s
    $WAIT > /dev/null # %WAIT% >nul
done

echo MAS started.
echo Press a key to shutdown the MAS
read -p "$*"
echo Halting the MAS...
killall sicstus
killall xterm
