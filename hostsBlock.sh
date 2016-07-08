#!/bin/bash

#Title: Hosts File URL Blocking
#Description: This script makes a backup of the hosts file
#and appends hosts file with URLs from block lists.
#Author: Jason Clark
#Credits: Block lists available at:
#http://winhelp2002.mvps.org/hosts.txt
#http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0
#http://someonewhocares.org/hosts/hosts
#http://www.malwaredomainlist.com/hostslist/hosts.txt

# If hosts file exists 
hostFile="/etc/hosts"
if [ -f "$hostFile" ]; then

   # Check to see if original hosts file backed up	
   backFile="/etc/hosts.bak"
   if [ -f "$backFile" ]; then
      echo "$backFile already exists."

   # Makes a backup copy of original hosts file
   else
      cp /etc/hosts /etc/hosts.bak
      echo "Host file backed up to $backFile."
fi

# Build array containing URLs. 
declare -a blockLists=('http://winhelp2002.mvps.org/hosts.txt'
		'http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0'
		'http://someonewhocares.org/hosts/hosts'
		'http://www.malwaredomainlist.com/hostslist/hosts.txt');

# Clear hosts file
echo " " > $hostFile

#Loop through array, appending hosts file
for i in "${blockLists[@]}"
do
   curl -s -L "$i" >> $hostFile
   echo "$i" " added to hosts file."
done

# Completion message
echo "Hosts file is complete."

# Hosts file was not found in /etc/hosts
else
   echo "The hosts file was not found."
   echo "Your OS may not be supported by this script."
fi
