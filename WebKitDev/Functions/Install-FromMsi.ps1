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
  The URL to download from.

  .Parameter NoVerify
  If set the installation is not verified by attempting to call an executable
  with the given name.

  .Parameter Options
  A list of options to pass in.
#>
Function Install-FromMsi {
    Param(
        [Parameter(Mandatory)]
        [string] $name,
        [Parameter(Mandatory)]
        [string] $url,
        [Parameter()]
        [switch] $noVerify = $false,
        [Parameter()]
        [string[]] $options = @()
    )

    $installerPath = Join-Path ([System.IO.Path]::GetTempPath()) ('{0}.msi' -f $name);

    Write-Host ('Downloading {0} installer from {1} ..' -f $name, $url);
    Invoke-WebFileRequest -Url $url -DestinationPath $installerPath;
    Write-Host ('Downloaded {0} bytes' -f (Get-Item $installerPath).length);

    $args = @('/i', $installerPath, '/quiet', '/qn');
    $args += $options;

    Write-Host ('Installing {0} ...' -f $name);
    Write-Host ('msiexec {0}' -f ($args -Join ' '));

    Start-Process msiexec -Wait -ArgumentList $args;

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
    Remove-TempFiles;

    Write-Host ('{0} install complete.' -f $name);
}
