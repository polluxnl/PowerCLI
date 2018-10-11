# ------------------------------------------------------------------------------------------------------------------
# PowerCLI script to create DRS affinity host groups for multiple stretched clusters
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

# Create array per stretched cluster to hold hosts belonging to that cluster

$siteA_C1 = New-Object System.Collections.ArrayList
$siteA_C2 = New-Object System.Collections.ArrayList
$siteB_C1 = New-Object System.Collections.ArrayList
$siteB_C2 = New-Object System.Collections.ArrayList

# Create variables for each cluster

$cluster1 = "Cluster1"
$cluster2 = "Cluster2"

# Create variables for each group name per cluster

$drsgrpA = "Site-A-Hosts"
$drsgrpB = "Site-B-Hosts"


# Loop through CSV file to add hosts to the correct arrays

Import-Csv hosts.txt | Foreach-Object {

    if ($_.site -eq "dcr" -and $_.cluster -eq $cluster1) {
      $siteA_C1.Add($_.hostname)
    }

    if ($_.site -eq "wpr" -and $_.cluster -eq $cluster1) {
      $siteB_C1.Add($_.hostname)
    }

    if ($_.site -eq "dcr" -and $_.cluster -eq $cluster2) {
      $siteA_C2.Add($_.hostname)
    }

    if ($_.site -eq "wpr" -and $_.cluster -eq $cluster2) {
      $siteB_C2.Add($_.hostname)
    }
}

# Create host DRS groups in Automation cluster

New-DrsClusterGroup -Name $drsgrpA -Cluster $cluster1 -VMHost $siteA_C1[0] -Confirm:$false
$siteA_C1.RemoveAt(0)

New-DrsClusterGroup -Name $drsgrpB -Cluster $cluster1 -VMHost $siteB_C1[0] -Confirm:$false
$siteB_C1.RemoveAt(0)

foreach ($h in $siteA_C1) {
    $C1_grp_A = Get-DrsClusterGroup -Cluster $cluster1 -Name $drsgrpA
    Set-DrsClusterGroup -DrsClusterGroup $C1_grp_A -Add -VMHost $h
}

foreach ($h in $siteB_C1) {
    $C1_grp_B = Get-DrsClusterGroup -Cluster $cluster1 -Name $drsgrpB
    Set-DrsClusterGroup -DrsClusterGroup $C1_grp_B -Add -VMHost $h
}

# Create host DRS groups in NEI cluster

New-DrsClusterGroup -Name $drsgrpA -Cluster $cluster2 -VMHost $siteA_C2[0] -Confirm:$false
$siteA_C2.RemoveAt(0)

New-DrsClusterGroup -Name $drsgrpB -Cluster $cluster2 -VMHost $siteB_C2[0] -Confirm:$false
$siteB_C2.RemoveAt(0)

foreach ($h in $siteA_C2) {
    $C2_grp_A = Get-DrsClusterGroup -Cluster $cluster2 -Name $drsgrpA
    Set-DrsClusterGroup -DrsClusterGroup $C2_grp_A -Add -VMHost $h
}

foreach ($h in $siteB_C2) {
    $C2_grp_B = Get-DrsClusterGroup -Cluster $cluster2 -Name $drsgrpB
    Set-DrsClusterGroup -DrsClusterGroup $C2_grp_B -Add -VMHost $h
}