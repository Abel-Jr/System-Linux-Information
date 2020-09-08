#!/bin/bash

   echo " OUR SCRIPT WE'LL BE EXECUTED IN A COUPLE OF SECONDS, PLEASE WAIT "
   echo " "
   echo " MAKE SURE, YOU'RE CONNECTED AS ROOT ACCOUNT "
   echo "***********************************"
   

if [ "$(id -u)" != "0" ]
   then
     echo " Sorry but like announced before you have to be root to excute this script " 
     echo ""
     echo " This incident will be reported to the system " 1>&2
     sleep 2s
     exit 1

else
   echo " You're connected as root, do you want to continue ?, Enter yes or no "
   read answer

   if [[ $answer = "yes" ]];
      then
        echo " Excecution will started soon "
        echo ""
        
        echo " This script will retieve information about your system " 
        echo " Please wait " 
        sleep 2s
        echo "" 
        sudo apt-get update -y
        sudo apt-get upgrade -y
        echo ""
 
       echo "Information about OS name and Linux kernel version "
       echo " "
       hostnamectl
       echo " "
       sleep 3s
       
       echo "LSB and distributed-specific information"
       echo ""
       lsb_release -a

       echo "Successfull Connection "
       echo ""
       last
       echo ""
       echo "Unsucessfull Connection "
       sudo lastb
       echo " "
       sleep 1s
       
       # Users properties
       
       echo "Try to get all system's users"
       sudo apt install finger -y
       echo " "
       echo "So now whe have "
       touch users.txt
       chmod g-r,o-r users.txt
       getent passwd | cut -d: -f1 > users.txt
  
       sleep 1s
       clear

  
       while read line  
       do   
          echo -e "             $line          " 
          echo ""
          sudo chage -l $line
          echo "  "
          echo "  Permissions  "
          echo ""
          sudo -l -U $line
          sleep 1s
          echo " "
          echo " Information about $line "
          echo " "
          sudo finger $line
          echo " "
          sleep 4s
          echo "********"
          echo " "
       done < users.txt
 
       rm users.txt
       
       sleep 3s
       # Path Environment 
       echo " "
       echo "   PATH Environment      "
       echo " "
       echo $PATH
 
      sleep 2s
      echo "  "
      echo "  Connected devices    "
      echo "   "
      sudo lsusb
      sleep 3s
      
      # Partitions
      echo " "
      echo "   Draw partitions       "
      sleep 1s
      sudo fdisk -l 
      
      echo "   "
      echo " Do you want to change something, enter 1 or 2 "
      echo " 1) yes "
      echo " 2) no "
      echo "  "
      read answer
 
      if [[ $answer -eq 1 ]];
         then
             echo "   Which is your disk, e.g sda,sdb,.."
             read disk
             
             sudo fdisk /dev/$disk
    
      elif [[ $answer -eq 2 ]];
         then
             echo "  Skip  "
      else
             echo " Not a good input  "
      fi
 
      # Block devices
      echo "  "
      echo "  List block devices   "
      echo " "
      sleep 1s
      sudo lsblk -f
      echo " "
      # Ufw status
      
      echo " Check for ufw  "
      echo " "
      sudo apt install ufw -y
      sudo " "
      sudo ufw enable
      
      echo "Do you want to add a rule, delete or pass press 1,2 or anything else "
      echo "1) Add a rule "
      echo "2) Delete a rule"
      read ans
     
     # Add a rule
 
      if [[ $ans -eq 1 ]];
          then
             echo "Which action do you want to run ? Allow or Deny, press 1 or 2"
             echo "1) Allow"
             echo "2) Deny"
             read act
       
             if [[ $act -eq 1 ]]; 
                then
                  action="allow"
             elif [[ $act -eq 2 ]]; 
                then
                  action="deny"
             else
                echo " This input is not match with the recommendation, next time pay attention "
               
      
             fi
       

             echo "Enter incomnig adress"
             read ip_address
             
             if [[ ! -z $ip_address ]];
                 then
                   echo "Do you want to specify the outcoming, 1 for yes, 2 for no"
                   echo "1) yes"
                   echo "2) no"
                   read out_address
                   if [[ $out_address -eq 1 ]]; 
                      then
             	         echo "Enter outcoming adress"
             	         read add_out
             	         if [[ -z $add_out ]];
             	            then
             	            
             	             echo "You can't have blank space it will be replace by any"
                         else
                             
                             sudo ufw $action from $ip_address to $add_out
                         fi
                     
                   elif [[ $out_address -eq 2 ]];
                      then
                         sudo ufw $action from $ip_address
                   else
                      echo "This input is not 1 or 2"
                      echo $out_address
                   
                   fi
             fi
     
     
     ## Delete a rule    
      
      elif [[ $ans -eq 2 ]];
              then 

                  echo "Delete a rule, before let's display them"
                  echo " "
                  sudo ufw status
                  echo " Which one you want to delete "
                  echo "Enter the incoming ip adress"
                  read ip_add
                  if [[ ! -z $ip_add ]];
                         then
                             echo "Do you want to enter the outcoming adress, if not let is blank, if yes enter yes"
                             read yes
                             if [[ -z $yes ]];
                                  then
                                       sudo ufw delete allow from $ip_add
                             elif [[ $yes = "yes" ]];
                                  then
                                       echo "Enter the outcoming adress"
                                       read outcom
                                       if [[ ! -z $outcom ]];
                                            then
		                                sudo ufw delete allow from $ip_add to $outcom
                                       fi
                             else
                      
                              echo " Your input was incomprehensible "
                 
                             fi
                  else
         
                       echo " Caution, blank space"
           
                  fi

      

      else
        echo " "
      fi
      
      
      
       # Open Ports with net-tools
      echo "Done, we're about to install net-tools"
      apt-get install net-tools -y
      echo ""
      echo "Check open ports and process"
      netstat -ntlup
      echo "****"
      
      # APT directory
      echo "Check for a modification in APT directory"
      sleep 2s
      cat /var/log/apt/history.log
      echo "*******" 
      
      echo " "
      echo " Chrootkit "
      echo " "
      echo " This tool is lokking for most common and famous rootkit. "    
      echo " "
      sleep 1s
      sudo apt-get install chkrootkit -y
      echo " "
      echo " Now exceution"
      sleep 5s    
      chkrootkit
      echo " "
      echo " Rkhunter "
      echo ""
      echo " This tool is lokking for most common and famous rootkit. "    
      echo " "
    
      sudo apt-get install rkhunter -y
      echo " "
      echo " Completed Check "
      echo " " 
         
      # chkrootkit
      
      sleep 4s
      rkhunter --checkall
      echo " "
      echo " Errors or Warnings during scan "
      echo " "
      sleep 3s
      rkhunter -c --rwo
    
       # Clamav
       
      echo ""
      echo " Looking for potential virus "
      echo ""
      apt-get install clamav -y
    
      echo ""
      echo " Update the clamav database"
      sudo systemctl stop clamav-freshclam.service
      sleep 3s
      sudo freshclam

    
    
      echo " "
      echo " Scan "
      echo " "
      clamscan -v /usr/bin/

      # Snort
      
      echo " "
      echo " Snort "
      apt-get install snort -y
     
      echo " "
      echo " Monitoring " 
      sudo snort -A full -q -u snort -g snort -c /etc/snort/snort.conf -s  -i ens33

      # Processes
      
      echo "Displays all process"
      ps -ef
      echo " ** "
 
      # Firewall Logs
      
      echo " "
      
      if [[ -f /var/log/ufw.log ]];
         then
             echo "  Firewall logs "
             echo "  "
             sleep 2s
             cat /var/log/ufw.log
             echo "  "
      fi
      
     
   


   elif [[ $answer = "no" ]];
      then
        echo " We will be taking to the prompt, Goodbye"
	exit 1
   else
        exit 1
   fi

        exit 1
fi


