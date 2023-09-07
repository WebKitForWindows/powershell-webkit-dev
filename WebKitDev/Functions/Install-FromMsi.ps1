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
function Install-FromMsi {
    param(
        [Parameter(Mandatory)]
        [string]$name,
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter()]
        [switch]$noVerify = $false,
        [Parameter()]
        [string[]]$options = @()
    )

    $installerPath = Join-Path ([System.IO.Path]::GetTempPath()) ('{0}.msi' -f $name);

    Write-Information -MessageData ('Downloading {0} installer from {1} ..' -f $name,$url) -InformationAction Continue;
    Invoke-WebFileRequest -url $url -DestinationPath $installerPath;
    Write-Information -MessageData ('Downloaded {0} bytes' -f (Get-Item $installerPath).Length) -InformationAction Continue;

    $msiArgs = @('/i',$installerPath,'/quiet','/qn');
    $msiArgs += $options;

    Write-Information -MessageData ('Installing {0} ...' -f $name) -InformationAction Continue;
    Write-Information -MessageData ('msiexec {0}' -f ($msiArgs -join ' ')) -InformationAction Continue;

    # According to https://stackoverflow.com/a/23797762 caching the handle is required to get ExitCode
    $process = Start-Process msiexec -Passthru -ArgumentList $msiArgs;
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments','',Scope = 'Function')]
    $handle = $process.Handle;
    $process.WaitForExit();

    if ($process.ExitCode -ne 0) {
        Write-Error ('{0} installer failed with exit code {1}' -f $name,$process.ExitCode) -ErrorAction Stop;
    }

    # Update path
    Update-ScriptPath;

    if (!$noVerify) {
        Write-Information -MessageData ('Verifying {0} install ...' -f $name) -InformationAction Continue;
        $verifyCommand = ('  {0} --version' -f $name);
        Write-Information -MessageData $verifyCommand -InformationAction Continue;
        Invoke-Expression $verifyCommand;
    }

    Write-Information -MessageData ('Removing {0} installer ...' -f $name) -InformationAction Continue;
    Remove-Item $installerPath -Force;
    Remove-TempFiles;

    Write-Information -MessageData ('{0} install complete.' -f $name) -InformationAction Continue;
}
