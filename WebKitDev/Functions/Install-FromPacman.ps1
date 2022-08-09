# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs a MSYS2 package through pacman.

  .Description
  Downloads a MSYS2 package from pacman onto the system.

  .Parameter Name
  The name of the package.

  .Parameter NoVerify
  If set the installation is not verified by attempting to call an executable
  with the given name.

  .Parameter Options
  A list of options to pass in.
#>
function Install-FromPacman {
    param(
        [Parameter(Mandatory)]
        [string]$name,
        [Parameter()]
        [string]$verifyExe = '',
        [Parameter()]
        [switch]$noVerify = $false
    )
    $bash = Get-Command 'bash' -ErrorAction 'SilentlyContinue';
    if ($bash -eq $null) {
        Write-Error ('Could not find bash to use to install {0}' -f $name);
        return
    }

    # Temp file for output
    # MSYS2 has a problem with interactive docker shells so just pipe output
    # to a temporary file and read from that to get results of commands.
    # https://github.com/msys2/MSYS2-packages/issues/1490
    $outFile = New-TemporaryFile;

    $bashCmd = ('pacman --noconfirm -S {0}' -f $name);
    $bashExpression = ("bash -lc '{0}'" -f $bashCmd);
    Write-Host $bashCmd;
    Invoke-Expression $bashExpression > $outFile;
    Get-Content $outFile;

    if (!$noVerify) {
        if ($verifyExe -eq '') {
            $verifyExe = $name;
        }
        Write-Host ('Verifying {0} install ...' -f $name);
        $verifyCommand = ('  {0} --version' -f $verifyExe);
        Write-Host $verifyCommand;
        Invoke-Expression $verifyCommand > $outFile;
        Get-Content $outFile;
    }

    Remove-Item $outFile;
}
