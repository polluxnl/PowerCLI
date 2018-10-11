
# ------------------------------------------------------------------------------------------------------------------
# PowerCLI script to add new ESXi hosts to the vCenter server and in the different clusters based on a CSV file
# with the hostname and the destination cluster.
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

Import-Csv hosts.txt | Foreach-Object {

  Add-VMHost $_.hostname -Location (Get-Datacenter "Datacenter1") -User root -Password VMware1! -RunAsync -force:$true -Confirm:$false
  Get-VMHost -Name $_.hostname | Set-VMHost -State Maintenance
  Get-VMHost -Name $_.hostname | Move-VMHost -Destination $_.cluster -RunAsync -Confirm:$false
  Get-VMHost -Name $_.hostname | Set-VMHost -State Connected