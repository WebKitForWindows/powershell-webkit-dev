# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs CMake.

  .Description
  Downloads the specified release of CMake and installs it silently on the host.

  .Parameter Version
  The version of CMake to install.

  .Parameter InstallationPath
  The location to install to.

  .Example
    # Install 3.7.2
    Install-CMake -Version 3.7.2
#>
function Install-CMake {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter()]
        [AllowNull()]
        [string]$installationPath
    )

    $installerOptions = @('ADD_CMAKE_TO_PATH=System');

    if ($installationPath) {
        $installerOptions += ('INSTALL_ROOT="{0}"' -f $installationPath);
    }

    Install-FromChoco `
         -Name 'cmake' `
         -Version $version `
         -Options @('--apply-install-arguments-to-dependencies') `
         -InstallerOptions $installerOptions;
}
