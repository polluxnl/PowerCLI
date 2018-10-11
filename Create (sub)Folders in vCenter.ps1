# ------------------------------------------------------------------------------------------------------------------
# PowerCLI script to create a vCenter folder structure
#
# By Wesley van Ede, www.dutchvblog.com
#
# ------------------------------------------------------------------------------------------------------------------

# Set datacenter

$datacenter = Datacenter1

# Create top level folders

$location = Get-Datacenter -Name $datacenter | Get-Folder -Name "vm"
$folders = 
"Management",
"VRM",
"Templates",
"Jump Hosts",
"Automation",
"Backup",
"vCenter",
"vCenter Update Manager",
"SQL"

foreach ($folder in $folders) {
    New-Folder -Name $folder -Location $location
    }

# Create sub-folders Automation

$location_automation = Get-Datacenter -Name $datacenter | Get-Folder -Name "Automation"
$aut_folders = 
"vROps",
"vRO",
"vRLI",
"vRA",
"NSX"

foreach ($folder in $aut_folders) {
    New-Folder -Name $folder -Location $location_automation
    }

# Create sub-folders NSX

$location_nsx = Get-Datacenter -Name $datacenter | Get-Folder -Name "NSX"
$nsx_folders = 
"dLR's",
"Load Balancers",
"Edge Service Gateways",
"Controllers"

foreach ($folder in $nsx_folders) {
    New-Folder -Name $folder -Location $location_nsx
    }