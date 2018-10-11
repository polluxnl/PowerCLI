# ------------------------------------------------------------------------------------------------------------------
# PowerCLI script to remove vSwitch0 from all hosts after they are migrated to the Distributed Switch
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

Write-Host "Removing virtual switch vSwitch0"
Remove-VirtualSwitch -VirtualSwitch vSwitch0 -Confirm:$false