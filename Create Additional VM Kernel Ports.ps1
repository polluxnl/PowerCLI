# ------------------------------------------------------------------------------------------------------------------
# PowerCLI script to create VMK ports other then the management VMK port
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

# Get VDSwitch and Portgroup objects

$vds = Get-VirtualSwitch -Name "VDS-01"
$pg1 = Get-VirtualPortGroup -Name "PG-30-vMotion1"
$pg2 = Get-VirtualPortGroup -Name "PG-30-vMotion2"
$pg3 = Get-VirtualPortGroup -Name "PG-40-FT"

# Loop through CSV file with hostnames to add VMK's to each host

Import-Csv hosts.txt | Foreach-Object {

  New-VMHostNetworkAdapter -VMHost $_.hostname -PortGroup $pg1 -VirtualSwitch $vds -Mtu 9000 -VMotionEnabled:$true
  New-VMHostNetworkAdapter -VMHost $_.hostname -PortGroup $pg2 -VirtualSwitch $vds -Mtu 9000 -VMotionEnabled:$true
  New-VMHostNetworkAdapter -VMHost $_.hostname -PortGroup $pg3 -VirtualSwitch $vds -Mtu 9000 -FaultToleranceLoggingEnabled:$true
}