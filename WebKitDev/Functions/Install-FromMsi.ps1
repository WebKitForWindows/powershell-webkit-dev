# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Downloads an installs a MSI package.

  .Description
  Downloads the specified release of Git for Windows and installs it silently
  on the host.

  .Parameter Name
  The name of the package.

  .Parameter Url
  The URL to download from.

  .Parameter Options
  A list of options to pass in.

  .Example
    # Install 2.12.1
    Install-Git -Version 2.12.1 -BuildNumber 1
#>
Function Install-FromMsi {
  Param(
    [Parameter(Mandatory)]
    [string] $name,
    [Parameter(Mandatory)]
    [string] $url,
    [Parameter(Mandatory)]
    [string[]] $options
  )

  $installerPath = Join-Path ([System.IO.Path]::GetTempPath()) ('{0}.msi' -f $name);

  Write-Host ('Downloading {0} installer from {1} ..' -f $name, $url);
  (New-Object System.Net.WebClient).DownloadFile($url, $installerPath);
  Write-Host ('Downloaded {0} bytes' -f (Get-Item $installerPath).length);

  $args = @('/i', $installerPath);
  $args += $options;

  Write-Host ('Installing {0} ...' -f $name);
  Write-Host ('msiexec {0}' -f ($args -Join ' '));

  Start-Process msiexec -Wait -ArgumentList $args;

  # Update path
  Update-ScriptPath;

  Write-Host ('Verifying {0} install ...' -f $name);
  $verifyCommand = ('  {0} --version' -f $name);
  Write-Host $verifyCommand;
  Invoke-Expression $verifyCommand;

  Write-Host ('Removing {0} installer ...' -f $name);
  Remove-Item $installerPath -Force;

  Write-Host ('{0} install complete.' -f $name);
}
