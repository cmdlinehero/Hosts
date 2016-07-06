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

# Check if hosts file exists 
hostFile="/etc/hosts"
if [ -f "$hostFile" ]; then
   echo "$hostFile found."
else
   echo "$hostFile not found."
fi

# Check if hosts backup file exists 
backFile="/etc/hosts.bak"
if [ -f "$backFile" ]; then
   echo "$backFile already exists."
else
   cp /etc/hosts /etc/hosts.bak
   echo "Host file backed up to $backFile."
fi

# Build array of block list URLs
declare -a blockLists=('http://winhelp2002.mvps.org/hosts.txt'
		'http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0'
		'http://someonewhocares.org/hosts/hosts'
		'http://www.malwaredomainlist.com/hostslist/hosts.txt');

# Clear current hosts file
echo " " > $hostFile

# Loop through array and append data to hosts file
for i in "${blockLists[@]}"
do
   curl -s -L "$i" >> $hostFile
   echo "$i" " added to hosts file."
done

# Completion message
echo "Hosts file is complete."
