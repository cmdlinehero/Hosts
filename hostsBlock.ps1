<#	
	Title:			Hosts File URL Blocking
	Description:	This script makes a backup of the hosts file
					and appends hosts file with URLs from block lists.
	Author:			Jason Clark
	Credits:		Block lists available at:
					http://winhelp2002.mvps.org/hosts.txt
					http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0
					http://someonewhocares.org/hosts/hosts
					http://www.malwaredomainlist.com/hostslist/hosts.txt
#>

# Check if hosts file exists and set path variable
if(Test-Path "C:\Windows\System32\drivers\etc\hosts") {
	$Path = "C:\Windows\System32\drivers\etc\hosts"
}

# Backup up original hosts file if backup does not exist
if(Test-Path "C:\Windows\System32\drivers\etc\hosts.bak") {
	Write-Host "Hosts backup file is already created."
}
else {
	Copy-Item $Path C:\Windows\System32\drivers\etc\hosts.bak
	Write-Host "Backed up hosts file to hosts.bak"
}

# Try/Catch to build array from URLs. Catch for no Internet
try {
	# Create array of URLs to fetch server lists
	$urlArray = "http://winhelp2002.mvps.org/hosts.txt", 
				"http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts;showintro=0",
				"http://someonewhocares.org/hosts/hosts",
				"http://www.malwaredomainlist.com/hostslist/hosts.txt"
	
	# Clears current hosts file
	Write-Output " " | Set-Content $Path

	# Loop through array and add to hosts file
	foreach ($element in $urlArray) {
		$result = Invoke-WebRequest $element
		Write-Output $result | Add-Content $Path
		Write-Host $element " list added to hosts file."
	}
}
catch {
	Write-Host "This script requires Internet access to fetch lists."
}
finally {
	exit
}