Set-Location 'C:\temp'
$featurekey = "windows_features:"
[array]$features = (Get-WindowsFeature | Where { $_.Installed -match 'True' }).Name

Write-Host "Determining Windows Features..."

$feature_array = @()
$feature_array += $featurekey

foreach ( $feature in $features ) {
  $feature_array += "  - " + $feature
}
$feature_array | Out-File "puppet_features_yaml.txt"
Write-Host "Windows Features written to puppet_features_yaml.txt."
Write-Host "Determining Packages..."

[array]$packages = (Get-WmiObject -Class Win32_Product).Name
$pkg_array = @()
foreach ( $package in $packages ) {
  $pkg_array += "package { '$package':"
  $pkg_array += "  ensure => present,"
  $pkg_array += "  source => `"\\path\to\msi`","
  $pkg_array += "  install_options => [ `"/qn`" ],"
  $pkg_array += "}"
}
$pkg_array | Out-File "puppet_package_manifest.txt"
Write-Host "Packages written to puppet_package_manifest.txt"