##########################################################
# Add vMotion VMkernel port for all servers in a cluster
#
##########################################################
# 
# VERSION - 1.2
#
param(   

	[Parameter(Mandatory=$true)]$vcenter,
	$vMotionIP = "172.21.1.0",
	$Subnet = "255.255.255.0",
	$vMotionVLAN = "43",
	$vMotionName = "vem_vsm_vsg_ctrl",
	$vmotion_ip_start = "172.21.1.53",
	$VMhost ="*",
	$clusterName = '*',
	$vms ='*'

)
##########################################################
function logout() {
	Disconnect-VIServer $server -confirm:$false
}
##########################################################    
$server = connect-viserver $vcenter

# Start Creating vMotion Network #################################################################################
$vmotion_ip_start_int=$vmotion_ip_start.split('.')
$vmotion_ip_start_int=[int]$vmotion_ip_start_int[3]

if (!$NOVMOTION){
Write-Host -ForegroundColor Yellow "Start Creating vMotion Network".ToUpper()
 
$cluster = Get-Cluster $clusterName | where {$_.name -notmatch 'AMP'}
if (!$cluster) {Write-host -foregroundcolor red "ERROR: ERROR: Cluster $clusterName cannot be found"; exit}
ForEach ($VMhostname in ($cluster | Get-VMHost -name $VMhost)| sort) 
 {
 
 	if ($VMhostname | Get-VMHostNetworkAdapter -VMKernel | where {$_.PortGroupName -match $vMotionName}) {
		Write-host -ForegroundColor yellow "WARNING : $VMhostname already has a VMkernel port named $vMotionName - Skipping"
	}
	else {
		
		write-host -ForegroundColor green "Creating vMotion port group for $VMhostname"
		$netIP = $vmotion_ip_start.split('.')
		$IP = $netIP[0] + '.' + $netIP[1] + '.' + $netIP[2] + '.' + $vmotion_ip_start_int
		$null = New-VMHostNetworkAdapter -VMHost $VMhostname -PortGroup $vMotionName -VirtualSwitch $(Get-VirtualSwitch -VMHost $VMhostname) -IP $IP -SubnetMask $Subnet -VMotionEnabled $true
		$null = Get-VirtualPortGroup -Name $vMotionName -VMHost $VMhostname | Set-VirtualPortGroup -VLanId $vMotionVLAN
		$vmotion_ip_start_int = $vmotion_ip_start_int +1
	}
	}
	Write-Host -ForegroundColor Green "End Creating vMotion Network".ToUpper()
	}
# End Creating vMotion Network ######################################################################################

