
#  DisableIpv6.ps1 - This script will get all hosts in the environment,and Disable IPV6
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

$null = Get-VMHost | Get-VMHostNetwork | Set-VMHostNetwork -IPv6Enabled $false
