# ------------------------------------------------------------------------------------------------------------------
# PowerCLI script to create datastore clusters and populate them according to a predefined list
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

$location = "Datacenter1"

Import-Csv DSClusters.txt | Foreach-Object {

  $exists = Get-DatastoreCluster -Name $_.DCname -ErrorAction SilentlyContinue

    If ($exists) {
      Write-Host Datastore Cluster with name $_.DCname already exists.
    }

    Else {
      New-DatastoreCluster -Name $_.DCname -Location $location
      Set-DatastoreCluster -DatastoreCluster $_.DCname -IOLatencyThresholdMillisecond 15 -IOLoadBalanceEnabled $false -SdrsAutomationLevel Disabled -SpaceUtilizationThresholdPercent 80
    }
}

Import-Csv DSClusters.txt | Foreach-Object {

  Move-Datastore -Confirm:$false -Datastore $_.DSname -Destination $_.DCname
}