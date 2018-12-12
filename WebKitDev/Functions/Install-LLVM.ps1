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
    # Install 7.0.0
    Install-LLVM -Version 7.0.0
#>
Function Install-LLVM {
    Param(
        [Parameter(Mandatory)]
        [string] $version,
        [Parameter()]
        [AllowNull()]
        [string] $installationPath
    )

    $url = "http://releases.llvm.org/${version}/LLVM-${version}-win64.exe"

    $options = @('/S')

    if ($installationPath) {
        $options += "/D=$installationPath"
    }

    Install-FromExe -Name 'LLVM' -Url $url -Options $options -noVerify
}
