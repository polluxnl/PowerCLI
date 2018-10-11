Function Get-DatastoreHeartbeatConfig  {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
            [String[]]$Cluster
            )
   Get-Cluster $Cluster  | select Name,@{E={$_.ExtensionData.Configuration.DasConfig.HBDatastoreCandidatePolicy};L="Heartbeat Policy"}
   }
   
Function Set-DatastoreHeartbeatConfig {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
            [String[]]$Cluster,
            [ValidateSet("allFeasibleDs","userSelectedDs","allFeasibleDsWithUserPreference")]
            [String[]]$Option
           )
   
    $Spec = New-Object VMware.Vim.ClusterConfigSpecEx
    $Spec.DasConfig = New-Object VMware.Vim.ClusterDasConfigInfo

    $ClusterName = Get-Cluster $Cluster

    if ($Option -eq "allFeasibleDs"){
        $Spec.DasConfig.HBDatastoreCandidatePolicy = "allFeasibleDs"
        $ClusterName.ExtensionData.ReconfigureComputeResource_Task($Spec, $true)
    }
    elseif ($Option -eq "userSelectedDs"){
        $Datastores = Get-Datastore | Out-Gridview -Title "Select only two datastores" -Passthru
        $Spec.dasConfig.heartbeatDatastore = New-Object VMware.Vim.ManagedObjectReference[](2)
        $Spec.dasConfig.heartbeatDatastore[0] = New-Object VMware.Vim.ManagedObjectReference
        $Spec.dasConfig.heartbeatDatastore[0].type = "Datastore"
        $Spec.dasConfig.heartbeatDatastore[0].Value = $Datastores[0].ExtensionData.MoRef.Value
        $Spec.dasConfig.heartbeatDatastore[1] = New-Object VMware.Vim.ManagedObjectReference
        $Spec.dasConfig.heartbeatDatastore[1].type = "Datastore"
        $Spec.dasConfig.heartbeatDatastore[1].Value = $Datastores[1].ExtensionData.MoRef.Value
        $Spec.DasConfig.HBDatastoreCandidatePolicy = "userSelectedDs"
        $ClusterName.ExtensionData.ReconfigureComputeResource_Task($Spec, $true)
    }
    elseif ($Option -eq "allFeasibleDsWithUserPreference"){
        $Datastores = Get-Datastore | Out-Gridview -Title "Select only two datastores" -Passthru
        $Spec.dasConfig.heartbeatDatastore = New-Object VMware.Vim.ManagedObjectReference[](2)
        $Spec.dasConfig.heartbeatDatastore[0] = New-Object VMware.Vim.ManagedObjectReference
        $Spec.dasConfig.heartbeatDatastore[0].type = "Datastore"
        $Spec.dasConfig.heartbeatDatastore[0].Value = $Datastores[0].ExtensionData.MoRef.Value
        $Spec.dasConfig.heartbeatDatastore[1] = New-Object VMware.Vim.ManagedObjectReference
        $Spec.dasConfig.heartbeatDatastore[1].type = "Datastore"
        $Spec.dasConfig.heartbeatDatastore[1].Value = $Datastores[1].ExtensionData.MoRef.Value
        $Spec.DasConfig.HBDatastoreCandidatePolicy = "allFeasibleDsWithUserPreference"
        $ClusterName.ExtensionData.ReconfigureComputeResource_Task($Spec, $true)
    }
}