# Copyright (c) 2019, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Downloads an executable.

  .Description
  Downloads an executable and installs it at the specified location.

  .Parameter Name
  The name of the package.

  .Parameter Url
  The URL to download from.

  .Parameter InstallationPath
  The path to install at.

  .Parameter NoVerify
  If set the installation is not verified by attempting to call an executable
  with the given name.

  .Parameter VersionOptions
  The options to pass to the executable to get the version.
#>
function Install-FromExeDownload {
    param(
        [Parameter(Mandatory)]
        [string]$name,
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter(Mandatory)]
        [string]$installationPath,
        [Parameter()]
        [switch]$noVerify = $false,
        [Parameter()]
        [string[]]$versionOptions = @('--version')
    )

    # Create directory if necessary
    if (!(Test-Path $installationPath)) {
        [void](New-Item -Path $installationPath -ItemType 'Directory');
    }

    $exePath = Join-Path $installationPath ('{0}.exe' -f $name);
    Write-Information -MessageData ('Downloading {0} executable from {1} ...' -f $name,$url) -InformationAction Continue;
    Invoke-WebFileRequest -url $url -DestinationPath $exePath;
    Write-Information -MessageData ('Downloaded {0} bytes' -f (Get-Item $exePath).Length) -InformationAction Continue;

    # Update path
    Update-ScriptPath;

    if (!$noVerify) {
        Write-Information -MessageData ('Verifying {0} install ...' -f $name) -InformationAction Continue;
        $verifyCommand = ('  {0} {1}' -f $name,(' ' -join $versionOptions));
        Write-Information -MessageData $verifyCommand -InformationAction Continue;
        Invoke-Expression $verifyCommand;
    }

    Write-Information -MessageData ('{0} install complete.' -f $name) -InformationAction Continue;
}
