
#  Remove-vMotion.ps1 - This script will get all hosts in the environment,and Disable IPV6
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


param(   




$PGName = "WSDC_PROD_ESX_VMOTION",
$VMhost='*',
$VMName = '*',
$VMMac = '*'	
	
)


#Connect to vCenter
Write-Verbose "Connecting to vCenter"



ForEach ($VMhostname in (Get-VMHost -name $VMhost)| sort) 

{

$delVMP = Get-VirtualPortGroup -Name $PGName -VirtualSwitch $(Get-VirtualSwitch -VMHost $VMhostname -Name vSwitch0)
$null = $delVMP | Remove-VirtualPortGroup -confirm:$false
}

