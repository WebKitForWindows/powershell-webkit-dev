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

    # Releases after 10.0 moved to GitHub
    $url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/LLVM-${version}-win64.exe"

    $options = @('/S')

    if ($installationPath) {
        $options += "/D=$installationPath"
    }

    Install-FromExe -Name 'LLVM' -url $url -options $options -noVerify
}
