#!/bin/bash
#Put me in the Eclipse directory that has the bin (and src) directories
#Typically this is the project directory
#Run me from the terminal, with as current directory the directory I'm in
#Comment and uncomment cpath variable depending on whether you have a version with
#or without aspectj aspects woven in

#version with aj aspects woven in -- be sure this is the correct path to aspectjrt.jar!
cpath=bin:lib/swt.jar:lib/aspectjrt.jar

#version without aj aspects woven in
#cpath=bin

echo "Running rmiregistry"
export CLASSPATH=$cpath

rmiregistry 10000 &
sleep 1

echo "Running server"
java -classpath $cpath cc71p.slotmachine.rmi.SlotMachineServer localhost 10000

echo "Server quitting, killing rmiregistry"
killall rmiregistry
