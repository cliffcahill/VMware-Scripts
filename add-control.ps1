##########################################################
# Add vMotion VMkernel port for all servers in a cluster
#
##########################################################
# 
# VERSION - 1.2
#
param(   
	[Parameter(Mandatory=$true)]$vcenter,
	$clustername = '*',
	$networkIP = '172.21.1.0',
	$Subnet = '255.255.255.0',
	$VLAN = '31',
	$vmotionName ='ESX-Intranet-vmotion',
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

$cluster = Get-Cluster $clusterName
if (!$cluster) {Write-host -ForegroundColor red "ERROR: Cluster $clusterName cannot be found"; logout; exit}

$esxhosts = get-cluster $clusterName | where {$_.name -notmatch 'AMP'} | Get-VMhost | Sort Name
foreach ($esxhost in $esxhosts) {
	if ($esxhost | Get-VMHostNetworkAdapter -VMKernel | where {$_.PortGroupName -match $vmotionName}) {
		Write-host -ForegroundColor yellow "WARNING : $esxhost already has a VMkernel port named $vmotionName - Skipping"
	}
	else {
		write-host -ForegroundColor green "Creating Control port group for $esxhost"
		$netIP = $NetworkIP.split('.')
		$IP = $($esxhost | Get-VMHostNetworkAdapter -VMKernel -Name 'vmk0').ip.split('.')
		$IP = $netIP[0] + '.' + $netIP[1] + '.' + $netIP[2] + '.' + $IP[3]
		$null = New-VMHostNetworkAdapter -VMHost $esxhost -PortGroup $vmotionName -VirtualSwitch $(Get-VirtualSwitch -VMHost $esxhost) -IP $IP -SubnetMask $Subnet
		$null = Get-VirtualPortGroup -Name $vmotionName -VMHost $esxhost | Set-VirtualPortGroup -VLanId $VLAN
		if ($reboot) {
			$null = Restart-VMHost -VMHost $esxhost -confirm:$false -force
			write-host -ForegroundColor green "$esxhost Restarted"
		}
	}
}

logout