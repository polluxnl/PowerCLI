# ------------------------------------------------------------------------------------------------------------------
# PowerCLI script to change local datastore names ie. datastore1 (1) -> hostname-local
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

Import-Csv hosts.txt | ForEach-Object {
    get-vmhost -name $_.hostname | Get-Datastore | where {$_.name -match "datastore1"} | Set-Datastore -name $_.DSname
}