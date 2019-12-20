#!/usr/bin/bash
###########################################################################
#
#
#   Very basic script for SAN Support
#
#          ozanuzun@gmail.com
#
###########################################################################



#########################################################################################
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version
########################################################################################	
#                          ABSOLUTELY NO WARRANTY :)


echo
echo "Printing any Fibre Cards/Ports if present"
echo
lspci | grep Fibre
echo



if [ -z $1 ]
then
for fc in `ls -d /sys/class/fc_host/host*`;do
FC_HOST=`basename $fc`
PortID=`cat $fc/port_id`
wwpn=`cat $fc/port_name`
state=`cat $fc/port_state`
speed=`cat $fc/speed`
fc=`cat $fc/symbolic_name`


echo "HOST: $FC_HOST"
echo "---------------------------------------------------------------------------"
echo "HBA WWPN : $wwpn PortId: $PortID"
echo "HBA State: $state Speed : $speed"
echo "SAN zone support : "
echo "$wwpn " | awk -F"x" {'print $2'} |sed 's/../&:/g' | sed 's/..$//'  
done
elif [ "$1" == "reset" ]
then 
echo "checking for new devices"
#############################
# Will check vsscsi and fc devices both
##########################
for host in `ls /sys/class/fc_host`; do echo "1" > /sys/class/fc_host/$host/issue_lip ; done
for host in `ls /sys/class/scsi_host`; do echo "- - -" > /sys/class/scsi_host/$host/scan; done
echo "done"
echo
else
echo "Usage: just dry run or "osan.sh reset" for disk scan"

fi
