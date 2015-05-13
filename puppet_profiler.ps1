Param(
  [string]$DataFormat,
  [string]$WorkDirectory,
  [string]$FeatureKey,
  [switch]$GetPackages
)

Write-Host "---WINDOWS PUPPET PROFILER---"
# Setting variables
[array]$features = ($getCmd | Where { $_.Installed -match 'True' }).Name

# Check 2008 or 2012
If (([environment]::OSVersion.Version.Minor) -eq 1) {
  $getCmd = "Import-Module ServerManager; Get-WindowsFeature"
} else {
  $getCmd = "Get-WindowsFeature"
}

# Conditional Logic for WorkDirectory
# Defaults to c:\TEMP
If (!($WorkDirectory)) { $WorkDirectory = 'C:\TEMP' }


# Function to validate and create the work directory
Function setWorkDirectory([string]$dir) {
  If ((Test-Path $WorkDirectory) -match 'False') {
    Write-Host "WorkDirectory does not exist.  Creating..."
    New-Item -ItemType Directory -Path $WorkDirectory
  }
  Write-Host "Changing to WorkDirectory of $WorkDirectory"
  Set-Location $WorkDirectory
}

#Function for dataformat as YAML
Function toYAML() {
  # Conditional Logic for FeatureKey
  # Defaults to windows_features
  If (!($FeatureKey)) { 
    [string]$FeatureKey = "windows_features"
  }
  $featureArray = @()
  $featureArray += "---"
  $featureArray += "$FeatureKey`:"
  foreach ($feature in $features) {
    $featureArray += "  - " + $feature
    }
  Write-Host "Writing feature data to $WorkDirectory\$FeatureKey.yaml"
  $featureArray | Out-File "$FeatureKey.yaml"
}    

#Function for dataformat as JSON
Function toJSON(){
  If (!($FeatureKey)) { 
    [string]$FeatureKey = "windows_features"
  }
  $featureHash = @{}
  $featureHash.$FeatureKey = $features
     
  ConvertTo-Json $featureHash | Out-File "$FeatureKey.json"
  Write-Host "Writing feature data to $FeatureKey.json"
}

Function toPuppet(){

# Conditional Logic for FeatureKey
# Defaults to windows_features
  If (!($FeatureKey)) { 
    [string]$FeatureKey = "windows_features"
  }
  $puppetArray = @()
  $puppetArray += "`$$FeatureKey = ["
  foreach ($feature in $features) {
    $puppetArray += "  `"$feature`","
  }
  $puppetArray += "],"
  $puppetArray | Out-File "$FeatureKey.pp"
  Write-Host "Writing feature data to sample puppet manifest $FeatureKey.pp"
}

# Gets packages and creates a sample manifest.
Function getPackages() {
  [array]$packages = (Get-WmiObject -Class Win32_Product).Name
  $pkg_array = @()
  foreach ( $package in $packages ) {
    $pkg_array += "package { '$package':"
    $pkg_array += "  ensure => present,"
    $pkg_array += "  source => `"\\path\to\msi`","
    $pkg_array += "  install_options => [ `"/qn`" ],"
    $pkg_array += "}"
  }
  $pkg_array | Out-File "packages.pp"
  Write-Host "Writing package sample manifest to packages.pp"
}

# Create and change to the work directory.
setWorkDirectory($WorkDirectory)

# Optional GetPackages
If ($GetPackages) { getPackages }

Write-Host "Determining Windows Features..."

# Conditional Logic for DataFormat
If (!($DataFormat)) { 
  Write-Host "No data format specified...defaulting to YAML"
  toYAML
}
elseif ($DataFormat -match 'JSON') { toJSON }
elseif ($DataFormat -match 'YAML') { toYAML }
elseif ($DataFormat -match 'Puppet') { toPuppet }
else {
  Write-Host "Invalid Data Source Format - Select JSON, YAML or Puppet"
  break
}

