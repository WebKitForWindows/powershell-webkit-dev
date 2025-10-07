# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs LLVM for Windows.

  .Description
  Downloads the specified release of LLVM for Windows and installs it silently
  on the host.

  .Parameter Version
  The version of LLVM for Windows to install.

  .Parameter InstallationPath
  The location to install to.

  .Example
    # Install 10.0.0
    Install-LLVM -Version 10.0.0
#>
function Install-LLVM {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter()]
        [AllowNull()]
        [string]$installationPath
    )

    $installerOptions = @()

    if ($installationPath) {
        Write-Warning 'The chocolatey package expects the standard location to be used';
        # NSIS installer will not accept " in the path even if there are spaces
        $installerOptions += ('/D={0}' -f $installationPath);
        Register-SystemPath (Join-Path $installationPath -ChildPath 'bin');
    }

    Install-FromChoco `
         -Name 'llvm' `
         -Version $version `
         -InstallerOptions $installerOptions `
         -VerifyExe 'clang-cl';
}
