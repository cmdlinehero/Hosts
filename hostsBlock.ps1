<#	
Title: Hosts File URL Blocking
Description: Script makes a backup of the hosts file
and appends hosts file with URLs made available by the
URL block lists in the credits below.
Author:	Jason Clark
Credits: Block lists available at:
	http://winhelp2002.mvps.org/hosts.txt
	http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0
	http://someonewhocares.org/hosts/hosts
	http://www.malwaredomainlist.com/hostslist/hosts.txt
#>

# If hosts file exists
if(Test-Path "C:\Windows\System32\drivers\etc\hosts") {

	# Set path variable to hosts file location
	$Path = "C:\Windows\System32\drivers\etc\hosts"

	# Checks to see if orginal host file already backed up
	if(Test-Path "C:\Windows\System32\drivers\etc\hosts.bak") {
		Write-Host "Hosts backup file is already created."
	}

	# Makes a backup of original hosts file
	else {
		Copy-Item $Path C:\Windows\System32\drivers\etc\hosts.bak
		Write-Host "Backed up hosts file to hosts.bak"
	}


	# Clear current hosts file
			Write-Output " " | Set-Content $Path

	# Build array containing URLs. Loop through array
	# and append data to hosts file
		$urlArray = "http://winhelp2002.mvps.org/hosts.txt", 
					"http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0",
					"http://someonewhocares.org/hosts/hosts",
					"http://www.malwaredomainlist.com/hostslist/hosts.txt"

		# Loop through array and add to hosts file
		foreach ($element in $urlArray) {
			$result = Invoke-WebRequest $element
			Write-Output $result | Add-Content $Path
			Write-Host $element " list added to hosts file."
		}
}

# If hosts file not found
else {
	Write-Host "The hosts file was not found."
	Write-Host "Your OS may not be supported by this script."
	exit
}