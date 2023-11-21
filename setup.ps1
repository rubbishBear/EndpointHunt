<#
Author: rubbishBear
#>

# Set the links
$sysmonURL = "https://download.sysinternals.com/files/Sysmon.zip"
$sysmonConfig = "https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml"
$splunkForwarder = "https://www.splunk.com/en_us/download/universal-forwarder.html"

# Download and extract Sysmon
Write-Host "Downloading latest version of Sysmon..."
Invoke-WebRequest $sysmonURL -OutFile .\sysmon.zip
Write-Host "Extracting Sysmon package..."
Expand-Archive -Path .\sysmon.zip -DestinationPath .\HuntPkg\SYSMON
Write-Host "Downloading latest version of Olaf Hartong's Symon config file"
Invoke-WebRequest $sysmonConfig -OutFile .\HuntPkg\SYSMON\sysmonconfig.xml

# Parse Splunk HTML for download links
$fwdReq = Invoke-WebRequest -Uri $splunkForwarder
$fwd_x64Link = $fwdReq.Links | Where-Object { $_."data-arch" -eq "x86_64" -and $_."data-platform" -eq "windows" } | Select-Object -Property "data-link"
$fwd_x86Link = $fwdReq.Links | Where-Object { $_."data-arch" -eq "x86" -and $_."data-platform" -eq "windows" } | Select-Object -Property "data-link"

# Download the latest x86 and x64 .msi Splunk Universal Forwarders
New-Item -ItemType Directory -Path .\HuntPkg -Name SPLUNK | Out-Null
Write-Host "Downloading the x64 Splunk Universal Forwarder..."
Invoke-WebRequest -Uri $fwd_x64Link."data-link" -OutFile .\HuntPkg\SPLUNK\SplunkForwarder64.msi
Write-Host "Downloading the x86 Splunk Universal Forwarder..."
Invoke-WebRequest -Uri $fwd_x86Link."data-link" -OutFile .\HuntPkg\SPLUNK\SplunkForwarder32.msi

# Cleanup
Write-Host "Cleaning up extra files..."
$removal = @(
    "sysmon.zip",
    ".\HuntPkg\SYSMON\Sysmon64a.exe",
    ".\HuntPkg\SYSMON\Eula.txt"    
)

Remove-Item $removal
Write-Host "Setup Complete!"