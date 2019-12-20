# ozantools
Ozan Tools are very basic but very effective tools to make your admin life easier



mtools.sh - Multipath devices statistics script, filters multipath device output. It very hard to monitor linux systems with many disks and 
            many paths. Default view is mpath device only, you can just filter per device with attached paths.
            Normally iostat,nmon,htop etc will output 16 paths for each lun/disk/device, but mtools will report one.


mcleaner.sh - Deleting devices is very error prone and dangerous  process in Linux. Especially there are 16 allieases for each disk.
              Mcleaner parses disks for you, effective but dumb. Be VERY carefull using this script. A good tool for experienced admins.
              
              
osan.sh      - A basic script for displaying hba/fc card data for linux. I do not know why you still had to crawl through un-userfriendly
               /sys paths. Just run osan.sh and it will output, speed, duplex, raw WWPN and WWPN with : for zoning.
               reset switch will trigger echo calls to sys filesystem for device search (like devfsadm in Solaris or cfgmgr AIX). 
               rescan_scsi bus script somehow does not work with some hba cards. osan.sh works.

