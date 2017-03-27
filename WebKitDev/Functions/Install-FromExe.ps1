# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Downloads an installs a MSI package.

  .Description
  Downloads a MSI package and silently installs it on the host. Any
  modifications to the system path are resolved after the installation.
  Additionally it can attempt to verify that the application installed
  correctly by calling it.

  .Parameter Name
  The name of the package.

  .Parameter Url
  The URL to download from

  .Parameter NoVerify
  If set the installation is not verified by attempting to call an executable
  with the given name.

  .Parameter Options
  A list of options to pass in.
#>
Function Install-FromExe {
  Param(
    [Parameter(Mandatory)]
    [string] $name,
    [Parameter(Mandatory)]
    [string] $url,
    [Parameter()]
    [switch] $noVerify = $false,
    [Parameter(Mandatory)]
    [string[]] $options = @()
  )

  $installerPath = Join-Path ([System.IO.Path]::GetTempPath()) ('{0}.exe' -f $name);

  Write-Host ('Downloading {0} installer from {1} ..' -f $name, $url);
  (New-Object System.Net.WebClient).DownloadFile($url, $installerPath);
  Write-Host ('Downloaded {0} bytes' -f (Get-Item $installerPath).length);

  Write-Host ('Installing {0} ...' -f $name);
  Write-Host ('{0} {1}' -f $installerPath, ($options -Join ' '));

  Start-Process $installerPath -Wait -ArgumentList $options;

  # Update path
  Update-ScriptPath;

  if (!$noVerify) {
    Write-Host ('Verifying {0} install ...' -f $name);
    $verifyCommand = ('  {0} --version' -f $name);
    Write-Host $verifyCommand;
    Invoke-Expression $verifyCommand;
  }

  Write-Host ('Removing {0} installer ...' -f $name);
  Remove-Item $installerPath -Force;

  Write-Host ('{0} install complete.' -f $name);
}
