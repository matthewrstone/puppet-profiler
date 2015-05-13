[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
$uri = "https://puppetmaster.vb.souldo.net:8140/packages/current/install.ps1"
$webobject = New-Object System.Net.WebClient
$link = $webobject.DownloadString($uri)
$installer = "puppet-enterprise-installer.ps1"
$temp = "C:\temp"

If ((Test-Path $temp) -like 'False') {
  New-Item -ItemType Directory -Path $temp
} else {
  Write-Host "Staging Directory Already Exists...Moving On..."
}

Write-Host "Changing to staging directory - $temp"
Set-Location -Path $temp

Write-Host "Downloading and installing Puppet Enterprise"
Invoke-WebRequest $uri -OutFile $temp\$installer
& $temp\$installer