# Copyright (c) 2025, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs a Windows package through chocolatey.

  .Description
  Installs a package from chocolatey onto the system.

  .Parameter Name
  The name of the package.

  .Parameter Version
  The version of the package to install.

  .Parameter Options
  A list of options to pass in.

  .Parameter InstallerOptions
  A list of options to pass to the installer.

  .Parameter PackageParameters
  A list of parameters to pass to the package.

  .Parameter NoVerify
  If set the installation is not verified by attempting to call an executable
  with the given name.

  .Parameter VerifyExe
  The executable to use to verify the installation. If not provided defaults to
  the name.

  .Parameter VersionOptions
  The options to pass to the executable to get the version.
#>
function Install-FromChoco {
    param(
        [Parameter(Mandatory)]
        [string]$name,
        [Parameter()]
        [string]$version,
        [Parameter()]
        [string[]]$options = @(),
        [Parameter()]
        [string[]]$installerOptions = @(),
        [Parameter()]
        [string[]]$packageParameters = @(),
        [Parameter()]
        [switch]$noVerify = $false,
        [Parameter()]
        [string]$verifyExe,
        [Parameter()]
        [string[]]$versionOptions = @('--version')
    )

    $chocoArgs = @('install',$name,'--confirm','--no-progress');

    if ($version) {
        $chocoArgs += @('--version',$version);
    }

    if ($installerOptions) {
        $joined = ($installerOptions -join ' ');
        $chocoArgs += ('--install-arguments="{0}"' -f ($joined -replace '"','""'));
    }

    if ($packageParameters) {
        $joined = ($packageParameters -join ' ');
        $chocoArgs += ('--package-parameters="{0}"' -f ($joined -replace '"','""'));
    }

    $chocoArgs += $options;

    Write-Information -MessageData ('choco {0}' -f ($chocoArgs -join ' ')) -InformationAction Continue;
    $startTime = Get-Date;
    $process = Start-Process choco -Passthru -NoNewWindow -ArgumentList $chocoArgs;
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments','',Scope = 'Function')]
    $handle = $process.Handle;
    $process.WaitForExit();
    $endTime = Get-Date;

    if ($process.ExitCode -ne 0) {
        Write-Error ('{0} installer failed with exit code {1}' -f $name,$process.ExitCode) -ErrorAction Stop;
        return;
    }

    # Update path
    Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1;
    refreshenv;

    if (!$noVerify) {
        if (!$verifyExe) {
            $verifyExe = $name;
        }

        Write-Information -MessageData ('Verifying {0} install ...' -f $name) -InformationAction Continue;
        $verifyCommand = ('  {0} {1}' -f $verifyExe,($versionOptions -join ' '));
        Write-Information -MessageData $verifyCommand -InformationAction Continue;
        Invoke-Expression $verifyCommand;
    }

    Write-Information -MessageData ('Installation of {0} completed in {1:mm} min {1:ss} sec' -f $name,($endTime - $startTime)) -InformationAction Continue;
}
