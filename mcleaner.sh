  #!/usr/bin/bash
 
  ########################################################################
  #
  #         Very dangerous script for multipath device removal
  #         Aim is elimination of human error
  #         Deleting multipath devices is error prone on big systems
  #			Script is not intelligent but might help
  #         Absolutely no guarantee
  #         USE it on your OWN risk!!
  #        
  #         It only supports friendly_names for now  
  #
  #           										ozanuzun@gmail.com
  #
 ##############################################################################  
 
 
 #########################################################################################
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version
########################################################################################	
#                          ABSOLUTELY NO WARRANTY :)


  stty erase ^H
  echo
  echo 
  echo -e "    Welcome to Ozan's multipath device remover:\n   "
  echo -e "    This script is very dangerous, use it on your own risk\n   "
  echo -e "    It does only support friendly_names in mpath devices!\n   "
  echo  -e "    Which one do you want to delete?:\n    "
  echo "--------------------------------------------------------"
  multipath -ll | grep dm-
  echo
  echo "--------------------------------------------------------"
  read -p "Please input your multipath device eg:wwid or mpathx: `echo $'\n> '`"  target
  
  output4=`multipath -ll  |grep $target |wc -l`

                  if [ $output4 -gt 1 ]
                    then
                     echo
                     echo "Be VERY carefull with your input, I see multiple devices"
                     echo "Please narrow your expression"
                     echo
                       multipath -ll  |grep $target
                     exit 2
                   fi

  echo
  echo "This is the device I will be deleting"
  echo
  echo "--------------------------------------------------------"
  multipath -ll | grep $target  > /dev/null
  
    output1=`echo $?`
               if [ $output1 -ne 0 ]
                 then
                 echo
                 echo "I think you mistyped"
                 echo "$target not found"
                 echo 
                 exit 1
                fi
            
  echo "--------------------------------------------------------"
  echo
  
  # Double check
  multipath -l $target  

  echo
  echo
  echo
  echo " I will delete those  devices "
  echo "--------------------------------------------------------"
  multipath -l $target  | grep  active | grep -v policy | awk -F"-" '{print $2}' |awk '{print $2}' 
  echo "--------------------------------------------------------"
  
  
  echo
  echo -e "           First review " 
  echo " I will destroy everything no matter what" 
  echo
  echo "--------------------------------------------------------"
  sleep 1
  echo
  echo -e "I will run the following commands\n\n"

  #This is to delete part
  for i in `multipath -l $target  | grep  active | grep -v policy | awk -F"-" '{print $2}' |awk '{print $2}'`
                       
      				do 
      				  echo   "echo 1 > /sys/block/$i/device/delete"
                    
      			done
      			
 echo
  read -p "         Continue (y/n)?" choice
case "$choice" in 
  y|Y ) echo -e "OK!\n\n"
  for i in `multipath -l $target  | grep  active | grep -v policy | awk -F"-" '{print $2}' |awk '{print $2}'`
                       
      				do 
      				  echo 1 > /sys/block/$i/device/delete
                    
      			done	
      			echo "--------------------------------------------------------"
      			echo
      			echo "         Disk delete command done"
      			echo 
      			echo -e " If they are deleted, it is time to remove mpath\n"
      		    echo "If you see no paths under the mpath device, I will delete it too"
      		    echo
                multipath -l $target 
                echo " 3 seconds to cancel"
                sleep 3
                multipath -f $target
                            #count=`multipath -l $target |wc -l`
                #  if [ $count -ge 2 ]
                #      then
                 #      echo 
                  #     echo " I still see some disks, paths!!"
                   #    echo 
                   # else
                    # echo " Cool, Lets do this"
                 # fi
                 echo 
                 echo "--------------------------------------------------------"
                 echo "multipath removal is done, it may give some errors while deleting"
                 echo 
                 echo "Let's check if the device is still present"
                 multipath -ll | grep $target
                 output2=`echo $?`
               				if [ $output2 -ne 0 ]
           				      then
           				      echo
          			          echo "The device seems to be removed"
               				  echo "$target not found"
                              echo "Success!"
                              echo
                              exit 0
                            else 
                             echo
                             echo "It did not succeed, please debug"	
                fi
            
                 
                 ;;
  
  n|N ) echo "Exiting"
        
         exit 0;;
  * ) echo "Invalid Selection"
          exit 2;;
 esac
  
  
  
  
  
  
  