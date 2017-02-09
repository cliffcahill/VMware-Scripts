##########################################################
#
#VAST: Gen 3.0
#Reference: Vblock System Logical Build Guide
#Script: AMP Deploy 340
#
#Date: 2013-11-28 12:05:25.
#											 
#Customer: INEO_Site1. 					 
#Vblock Model: 340-VNX-7600.				 
#
#Additional Instruction:	
#Check cell id is correct
#Check correct license keys have been entered in VAST
#														 
##########################################################


param(   




$folderName='*',
$VMhost='*',
$VMName = '*',
$VMMac = '*'	
	
)


#Connect to vCenter
Write-Verbose "Connecting to vCenter"



ForEach ($VMhostname in (Get-VMHost -name $VMhost)| sort) 

{
$PGName = "WSDC_PROD_ESX_VMOTION"
$delVMP = Get-VirtualPortGroup -Name "WSDC_PROD_ESX_VMOTION" -VirtualSwitch $(Get-VirtualSwitch -VMHost $VMhostname -Name vSwitch0)
$null = $delVMP | Remove-VirtualPortGroup -confirm:$false
}

