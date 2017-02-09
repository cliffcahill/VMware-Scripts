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
$VMhostname = "*",
$VMMac = '*'	
	
)


#Connect to vCenter
Write-Verbose "Connecting to vCenter"



ForEach ($VMhostname in (Get-VMHost -name $VMhost)| sort) 

{
Remove-VmHostNtpServer -NtpServer 0.vmware.pool.ntp.org -VMHost $VMhostname -confirm:$false
Remove-VmHostNtpServer -NtpServer 1.vmware.pool.ntp.org -VMHost $VMhostname -confirm:$false
}

$null = Get-VMHost | Get-VMHostNetwork | Set-VMHostNetwork -IPv6Enabled $false