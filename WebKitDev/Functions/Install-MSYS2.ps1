# Copyright (c) 2019, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs MSYS2.

  .Description
  Downloads the specified release of MSYS2 and installs it silently on the
  host.

  .Parameter Version
  The version of MSYS2 to install.

  .Parameter InstallationPath
  The location to install to.

  .Example
    # Install 20190524
    Install-MSYS2 -Version 20190524
#>
function Install-MSYS2 {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter(Mandatory)]
        [string]$installationPath,
        [Parameter()]
        [switch]$noPath = $false
    )

    $url = ('http://repo.msys2.org/distrib/x86_64/msys2-base-x86_64-{0}.tar.xz' -f $version)

    Install-FromArchive -Name 'msys2' -url $url -installationPath $installationPath -archiveRoot 'msys64' -noVerify;

    # Setup the environment
    #
    # This is taken from different dockerfiles that do not call `msys2_shell.cmd`.
    Write-Information -MessageData 'Initializing MSYS2 environment' -InformationAction Continue;
    $env:MSYSTEM = 'MSYS2';
    $env:MSYSCON = 'defterm';
    [Environment]::SetEnvironmentVariable('MSYSTEM',$env:MSYSTEM,[EnvironmentVariableTarget]::Machine);
    [Environment]::SetEnvironmentVariable('MSYSCON',$env:MSYSCON,[EnvironmentVariableTarget]::Machine);

    # Temp file for output
    # MSYS2 has a problem with interactive docker shells so just pipe output
    # to a temporary file and read from that to get results of commands.
    # https://github.com/msys2/MSYS2-packages/issues/1490
    $outFile = New-TemporaryFile;

    # Run bash a singular time
    Write-Information -MessageData '`n=================  STARTING BASH  =================`n' -InformationAction Continue;
    Set-Alias bash (Join-Path $installationPath -ChildPath 'usr' | Join-Path -ChildPath 'bin' | Join-Path -ChildPath 'bash.exe');
    bash.exe -lc 'exit 0' > $outFile;
    Get-Content $outFile;

    # Update steps taken from chocolatey package
    # https://github.com/msys2/msys2/wiki/MSYS2-installation
    Write-Information -MessageData 'Repeating system update until there are no more updates or max 5 iterations' -InformationAction Continue;
    $ErrorActionPreference = 'Continue'; # otherwise bash warnings will exit
    while (!$done) {
        Write-Information -MessageData '`n================= SYSTEM UPDATE $((++$i)) =================`n' -InformationAction Continue;
        bash.exe -lc 'pacman --noconfirm -Syuu' > $outFile;
        Get-Content $outFile;
        $done = (Get-Content $outFile) -match 'there is nothing to do' | Measure-Object | ForEach-Object { $_.Count -eq 2 };
        $done = $done -or ($i -ge 5);
    }
    Remove-Item $outFile;

    if (!$noPath) {
        # Add MSYS2 usr/bin to path
        Register-SystemPath (Join-Path $installationPath -ChildPath 'usr' | Join-Path -ChildPath 'bin');
    }
}
