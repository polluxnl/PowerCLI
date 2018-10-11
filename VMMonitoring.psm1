# ------------------------------------------------------------------------------------------------------------------
# Module to set VM Monitoring settings when configuring a cluster with HA (this is not yet part of the new-cluster
# cmdlet
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

function Set-ClusterDasVmMonitoring {

    param
    (
    [Parameter(Mandatory=$False,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage='What is the Cluster Name?')]
    [String[]]$cluster,
    [ValidateSet("vmMonitoringDisabled", "vmMonitoringOnly", "vmAndAppMonitoring")]
    [String[]]$Option,
    [int]$interval = 30,
    [int]$minup = 120,
    [int]$maxfail = 3,
    [int]$failwin = 3600
    )

    if(Get-Cluster $cluster){

    $spec = New-Object VMware.Vim.ClusterConfigSpecEx
    $spec.dasConfig = New-Object VMware.Vim.ClusterDasConfigInfo

        if ($option -eq "vmMonitoringDisabled" ) {
            $spec.dasConfig.vmMonitoring = "vmMonitoringDisabled"
            $spec.dasConfig.defaultVmSettings = New-Object VMware.Vim.ClusterDasVmSettings
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings = New-Object VMware.Vim.ClusterVmToolsMonitoringSettings
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.failureInterval = $interval
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.minUpTime = $minup
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.maxFailures = $maxfail
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.maxFailureWindow = $failwin

            $clusterobj = Get-Cluster -Name $cluster
            $clusterview = Get-View $clusterobj.Id
            $clusterview.ReconfigureComputeResource_Task($spec, $true)
            }

        elseif ($option -eq "vmMonitoringOnly" ) {
            $spec.dasConfig.vmMonitoring = "vmMonitoringOnly"
            $spec.dasConfig.defaultVmSettings = New-Object VMware.Vim.ClusterDasVmSettings
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings = New-Object VMware.Vim.ClusterVmToolsMonitoringSettings
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.failureInterval = $interval
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.minUpTime = $minup
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.maxFailures = $maxfail
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.maxFailureWindow = $failwin

            $clusterobj = Get-Cluster -Name $cluster
            $clusterview = Get-View $clusterobj.Id
            $clusterview.ReconfigureComputeResource_Task($spec, $true)
            }

        elseif ($option -eq "vmAndAppMonitoring" ) {
            $spec.dasConfig.vmMonitoring = "vmAndAppMonitoring"
            $spec.dasConfig.defaultVmSettings = New-Object VMware.Vim.ClusterDasVmSettings
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings = New-Object VMware.Vim.ClusterVmToolsMonitoringSettings
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.failureInterval = $interval
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.minUpTime = $minup
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.maxFailures = $maxfail
            $spec.dasConfig.defaultVmSettings.vmToolsMonitoringSettings.maxFailureWindow = $failwin

            $clusterobj = Get-Cluster -Name $cluster
            $clusterview = Get-View $clusterobj.Id
            $clusterview.ReconfigureComputeResource_Task($spec, $true)
            }

    }
}