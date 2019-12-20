#!/usr/bin/bash
#I hate when I try to delete on screen input !!
stty erase ^H
echo " Welcome to Ozan's Multipath Stat script"
echo
###############################################
#
# Multipath devices statistics script
# It is for filtering multipath device output
# script parses iostat data, that is all
# First started with parsing iostat standart output, became complex with many devices
# Now it sends output to text files for parsing
# v.0.1 basic functionality
# v.0.2 interactive mode
# v.0.3 filter corrections
#
#                     ozanuzun@gmail.com
#########################################


#########################################################################################
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version
########################################################################################	
#                          ABSOLUTELY NO WARRANTY :)

#########################################################################################
#
#
#
#                       FUNCTIONS
######################################################
#               interactive mode
######################################################
interactive () {
echo
echo
echo "Welcome to interactive, filtered mode" 
echo
echo "Which mpath device do you want to check?"
echo
echo "Please only input one device, it will filter that specific device&paths"

echo
multipath -l -v1

echo
echo "please input your mdevice:"

read input
echo
multipath -ll  |grep $input
output3=`echo $?`
               if [ $output3 -ne 0 ]
                 then
                 echo
                 echo "I think you mistyped"
                 echo "$input not found"
                 echo 
                 exit 1
                fi
output4=`multipath -ll  |grep $input |wc -l`

                  if [ $output4 -gt 1 ]
                    then
                     echo
                     echo "I can not filter multiple devices, yet"
                     echo "Please narrow your expression"
                     echo
                       multipath -ll  |grep $input 
                     exit 2
                   fi

echo "          $input selected"
echo
}
######################################################
#                      filtered mechanic
######################################################
device () {


echo "-------------------------------------------------------------------------------------------------------------------------"
iostat -yxm 2 1 > /tmp/iostatdetailed.tmp
######################
#Issues with friendly names
##############
multipath -ll | grep mpath >/dev/null
mpath=`echo $?`

if [ $mpath -eq 0 ]
then
multipath -l | grep $input | awk '{print $2}' | sed 's/.$//; s/^.//' > /tmp/omlist.tmp
now=$(cat /tmp/omlist.tmp  | head -1)
multipath -ll | grep $input | awk '{print $3}' | grep ^dm  > /tmp/dlist.tmp
else
multipath -l | grep $input | awk '{print $1}'  > /tmp/omlist.tmp
now=$(cat /tmp/omlist.tmp  | head -1)
multipath -ll | grep $input |  awk '{print $2}' | grep ^dm > /tmp/dlist.tmp
fi


multipath -l $now  | grep  active | grep -v policy | awk -F"-" '{print $2}' |awk '{print $2}' >> /tmp/dlist.tmp
     cat /tmp/dlist.tmp | while read i
        do
        grep -w  $i /tmp/iostatdetailed.tmp
        done



}

###############################################
#           total troughput
###############################################
total () {




iostat -mxy 2 1 > /tmp/iostat.tmp
iostat -mx 2 | head -6
while true
  do



multipath -ll | grep mpath >/dev/null 
mpath=`echo $?`

if [ $mpath -eq 0 ]
then
multipath -ll | grep dm | awk '{print $3}' | grep ^dm  > /tmp/omstat.tmp
else
multipath -ll | grep dm |  awk '{print $2}' | grep ^dm > /tmp/omstat.tmp

fi






    echo "-------------------------------------------------------------------------------------------------------------------------"
     iostat -yxm 2 1 > /tmp/iostat.tmp
     cat /tmp/omstat.tmp | while read i
         do
        grep -w $i /tmp/iostat.tmp
        done
   done
}



#########################################################################################




###############################################
# Array approach not anymore
# keep for versioning
#IFS=$'\n'
#grep -- "${a[*]}" files
#
#iostat -m 2| egrep "dm-0|dm-1"
###############################################

########################################################################
#
#           some options
#
#######################################################################

if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0`  for total output (default mode)"
  echo
  echo "`basename $0`  [multipath-device-shortname] eg:mpatha/dm-13/wwid"
  echo  for filtered mode
  echo
  echo "-i for interactive filteredmode"
  echo 
  exit 0

elif [ "$1" == "-i" ]
 then interactive
      multipath -ll | grep $input
      iostat -mx 2 | head -6
      while true
      do
      device
      done

 elif  [ -z $1 ]
  then echo
       total

 else
    input=$1
     multipath -ll  |grep $1
     output=$?	

        if [ $output -ne 0 ] 
         then
          echo "I can not find multipath device"
           exit 1
          else
            output2=`multipath -ll  |grep $1 |wc -l`

                  if [ $output2 -gt 1 ]
                    then
                     echo "I can not filter multiple devices, yet"
                     echo "Please narrow your expression"
                     exit 2
                   fi

         iostat -mx 2 | head -6
         while true
              do
              device
              done
       fi
fi

