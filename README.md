#puppet-profiler.ps1


### Description
Puppet Profiler is a script I have written to help in auditing Windows servers for attempts at configuration management with Puppet.  The script will grab a list of Windows Features and optionally installed software and create a data source or Puppet manifest for you.

### System Requirements
This script was written in Powershell for on Windows 2012.  Although there is logic for 2008, it has not been tested.  Feel free to open an issue or pull request if you would like further support.

### Usage
The script allows you specify your data format as well as an optional parameter to get packages.

#### Parameters

**-WorkDirectory** : Specify your work directory, defaults to c:\temp.

**-FeatureKey** : Choose a key name for your Windows Features.  Defaults to windows_features.

**-DataFormat** : Choose your data format - YAML, JSON or Puppet. Defaults to YAML

**-GetPackages** : Runs the optional package grabber, creating a very basic skeleton for all the package installation work you'll need to do.

#### Examples

Run in current directory and output to YAML.

	c:\puppet-profiler.ps1

Run in c:\elmo, output to JSON.

	c:\puppet_profiler.ps1 -DataFormat JSON -WorkDirectory c:\elmo

Output to Puppet manifests, get Packages.

	c:\puppet-profiler.ps1 -DataFormat Puppet -GetPackages