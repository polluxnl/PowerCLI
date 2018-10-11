# ------------------------------------------------------------------------------------------------------------------
# PowerCLI script to migrate all hosts in the different clusters to the VDSwitch
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

# Get VDSwitch object

$vds_name = "VDS-01"
$vds = Get-VDSwitch -Name $vds_name

# Set vmnic name

$nic1 = vmnic0
$nic2 = vmnic1
$nic3 = vmnic2
$nic4 = vmnic3

  # Loop through CSV file with hosts

  Import-Csv hosts.txt | Foreach-Object {

  # Add ESXi host to VDS

  Write-Host "Adding" $_.hostname "to" $vds_name
  $vds | Add-VDSwitchVMHost -VMHost $_.hostname

  # Migrate first 2 nics to VDS

  Write-Host "Adding $nic1 and $nic2 to" $vds_name
  $vmhostNetworkAdapter = Get-VMHost $_.hostname | Get-VMHostNetworkAdapter -Physical -Name $nic1
  $vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter -Confirm:$false
  $vmhostNetworkAdapter = Get-VMHost $_.hostname | Get-VMHostNetworkAdapter -Physical -Name $nic2
  $vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter -Confirm:$false

  # Migrate Management VMkernel interface to VDS

  $mgmt_portgroup = "PG-10-ESXi"
  $dvportgroup = Get-VDPortGroup -name $mgmt_portgroup -VDSwitch $vds
  $vmk = Get-VMHostNetworkAdapter -Name vmk0 -VMHost $_.hostname
  Write-Host "Migrating" $vmk "to" $vds_name
  Set-VMHostNetworkAdapter -PortGroup $dvportgroup -VirtualNic $vmk -confirm:$false

  # Migrate last 2 nics to VDS

  Write-Host "Adding $nic3 and $nic4 to" $vds_name
  $vmhostNetworkAdapter = Get-VMHost $_.hostname | Get-VMHostNetworkAdapter -Physical -Name $nic3
  $vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter -Confirm:$false
  $vmhostNetworkAdapter = Get-VMHost $_.hostname | Get-VMHostNetworkAdapter -Physical -Name $nic4
  $vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter -Confirm:$false
}