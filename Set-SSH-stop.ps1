# Set-SSS-ON - This script will get all hosts in the environment,and disables SSH
#
#	Author Cliff Cahill
#	
#	
#	
#	Parameters 
#		
#		-vCenter <String[]>
#			This is the IP address or hostname of the vCenter server
#		-verbose <Switch>
#			Specifies if there is verbose output
#
# Version - 1.0

Param(
	[Parameter(Mandatory=$true)]$vCenter,
	$clusterName = '*',
	$VMhostname ="*"
)


#Connect to vCenter
Write-Verbose "Connecting to vCenter"
$server = Connect-VIServer $vCenter -credential $(get-credential)

$currentLoc = Get-Location

$cluster = Get-Cluster $clusterName | where {$_.name -notmatch 'AMP'}
if (!$cluster) {Write-host -foregroundcolor red "Cluster $clusterName cannot be found"; exit}

#Loop through hosts
Write-Verbose "Get hosts and loop through to disbale ssh"
	
	Get-VMHost | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"} | Stop-VMHostService -confirm:$false

 
 
#Disconnect from vCenter
Disconnect-VIServer $server -confirm:$false