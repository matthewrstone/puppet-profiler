[array]$features = (Get-WindowsFeature | Where { $_.Installed -match 'True' }).Name

Write-Host "Determining Windows Features..."

Write-Host "windows_features:"
foreach ( $feature in $features ) {
  Write-Host "  - $feature"
}

Write-Host "Determining Packages..."

[array]$packages = (Get-WmiObject -Class Win32_Product).Name
foreach ( $package in $packages ) {
  Write-Host "package { '$package':"
  Write-Host "  ensure => present,"
  Write-Host "  source => `"\\path\to\msi`","
  Write-Host "  install_options => [ "/qn" ],"
  Write-Host "}"
}