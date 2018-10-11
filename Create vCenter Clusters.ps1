# ------------------------------------------------------------------------------------------------------------------
# Script to create vSphere clusters including the most common settings
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------
 
# Modules are psm1 files located in the user profile under \My Documents\WindowsPowerShell\Modules\<modulen_name>\<module_name.psm1> and are imported here
# to add functionality that is not yet present in the default cmdlets
 
Import-Module AdmissionConfig
Import-Module DsHeartBeatConfig
Import-Module VMCPSettings
Import-Module VMMonitoring
 
# Create initial datacenter object
 
$location = Get-Folder -NoRecursion
New-Datacenter -Name "Datacenter1" -Location $location
 
# Import and loop through a CSV file containing the clusters names, admission controll CPU and MEM percentage and if it is a stretched cluster
 
Import-Csv clusters.txt | Foreach-Object {
 
New-Cluster -Name $_.name -DrsAutomationLevel FullyAutomated -DrsEnabled -EVCMode "intel-haswell" -HAAdmissionControlEnabled -HAEnabled -HAIsolationResponse DoNothing -Location "Datacenter1" -VMSwapfilePolicy WithVM
 
Get-cluster -name $_.name | Set-HAAdmissionControlPolicy -percentCPU $_.admissionCPU -percentMem $_.admissionMEM
 
Get-Cluster -name $_.name | Set-DatastoreHeartbeatConfig -Option allFeasibleDs
 
Get-Cluster -name $_.name | Set-VMCPSettings -enableVMCP:$True -VmStorageProtectionForPDL restartAggressive -VmStorageProtectionForAPD restartConservative -VmReactionOnAPDCleared none -Confirm:$false
 
#Stretched clusters get extra settings
 
if ($_.isStretched -eq "true") {
 
    # To set the VM Monitoring values
    Set-ClusterDasVmMonitoring -cluster $_.name -Option vmMonitoringOnly -interval 50 -maxfail 3
 
    # Set advanced settings
    New-AdvancedSetting -Entity $_.name -Type ClusterHA -Name das.isolationaddress[0] -Value 10.10.10.1 -Confirm:$false
    New-AdvancedSetting -Entity $_.name -Type ClusterHA -Name das.isolationaddress[1] -Value 10.10.20.1 -Confirm:$false
    New-AdvancedSetting -Entity $_.name -Type ClusterHA -Name das.heartbeatdsperhost -Value 4 -Confirm:$false
    New-AdvancedSetting -Entity $_.name -Type ClusterHA -Name das.usedefaultisolationaddress -Value false -Confirm:$false
    }
}