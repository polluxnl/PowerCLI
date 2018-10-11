function Set-HAAdmissionControlPolicy{
    <#
    .SYNOPSIS
    Set the Percentage HA Admission Control Policy
    
    .DESCRIPTION
    Percentage of cluster resources reserved as failover spare capacity
    
    .PARAMETER  Cluster
    The Cluster object that is going to be configurered 
    
    .PARAMETER percentCPU
    The percent reservation of CPU Cluster resources
    
    .PARAMETER percentMem
    The percent reservation of Memory Cluster resources
    
    .EXAMPLE
    PS C:\> Set-HAAdmissionControlPolicy -Cluster $CL -percentCPU 50 -percentMem 50
    
    .EXAMPLE
    PS C:\> Get-Cluster | Set-HAAdmissionControlPolicy -percentCPU 50 -percentMem 50
    
    .NOTES
    Author: Niklas Akerlund / RTS
    Date: 2012-01-19
    #>
       param (
       [Parameter(Position=0,Mandatory=$true,HelpMessage="This need to be a clusterobject",
        ValueFromPipeline=$True)]
        $Cluster,
        [int]$percentCPU = 25,
        [int]$percentMem = 25
        )
        
        if(Get-Cluster $Cluster){
        
            $spec = New-Object VMware.Vim.ClusterConfigSpecEx
            $spec.dasConfig = New-Object VMware.Vim.ClusterDasConfigInfo
            $spec.dasConfig.admissionControlPolicy = New-Object VMware.Vim.ClusterFailoverResourcesAdmissionControlPolicy
            $spec.dasConfig.admissionControlPolicy.cpuFailoverResourcesPercent = $percentCPU
            $spec.dasConfig.admissionControlPolicy.memoryFailoverResourcesPercent = $percentMem
        
            $Cluster = Get-View $Cluster
            $Cluster.ReconfigureComputeResource_Task($spec, $true)
        }
    }