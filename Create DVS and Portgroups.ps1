# ------------------------------------------------------------------------------------------------------------------
# PowerCLI script to create the VDSwitch and all needed portgroups and their individual settings
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

# Create VDswitch

$vds_name = "VDS-01"
$vds = New-VDSwitch -Name $vds_name -Location (Get-Datacenter -Name "Datacenter1") -mtu 9000 -LinkDiscoveryProtocol LLDP -LinkDiscoveryProtocolOperation Listen -confirm:$false

# Create DVPortgroups

$pg1 = New-VDPortgroup -Name "PG-10-ESXi" -Vds $vds
$pg2 = New-VDPortgroup -Name "PG-20-Prod" -Vds $vds -VlanId 20
$pg3 = New-VDPortgroup -Name "PG-30-vMotion1" -Vds $vds -VlanId 30
$pg4 = New-VDPortgroup -Name "PG-30-vMotion2" -Vds $vds -VlanId 30
$pg5 = New-VDPortgroup -Name "PG-40-FT" -Vds $vds -VlanId 40

# Adjust DVPortgroup Setting Load Based Teaming

Get-VDSwitch -Name $vds | Get-VDPortgroup -Name $pg1 | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -LoadBalancingPolicy LoadBalanceLoadBased
Get-VDSwitch -Name $vds | Get-VDPortgroup -Name $pg2 | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -LoadBalancingPolicy LoadBalanceLoadBased
Get-VDSwitch -Name $vds | Get-VDPortgroup -Name $pg5 | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -LoadBalancingPolicy LoadBalanceLoadBased

# Adjust DVPortgroup Setting Active Uplinks

Get-VDSwitch -Name $vds | Get-VDPortgroup -Name $pg3 | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -ActiveUplinkPort uplink1
Get-VDSwitch -Name $vds | Get-VDPortgroup -Name $pg3 | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort uplink2
Get-VDSwitch -Name $vds | Get-VDPortgroup -Name $pg4 | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -ActiveUplinkPort uplink2
Get-VDSwitch -Name $vds | Get-VDPortgroup -Name $pg4 | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort uplink1