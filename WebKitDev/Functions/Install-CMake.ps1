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

    $major,$minor,$patch = $version.split('.');

    # CMake releases moved to GitHub in 3.20
    if (([int]$major -ge 4) -or (([int]$major -eq 3) -and ([int]$minor -ge 20))) {
        $url = ('https://github.com/Kitware/CMake/releases/download/v{0}/cmake-{0}-windows-x86_64.msi' -f $version)
    }
    else {
        $url = ('https://cmake.org/files/v{0}.{1}/cmake-{2}-win64_x64.msi' -f $major,$minor,$version);
    }

    $options = @(
        'ADD_CMAKE_TO_PATH="System"'
    );

    if ($installationPath) {
        $options += ('INSTALL_ROOT="{0}"' -f $installationPath);
    }

    Install-FromMsi -Name 'cmake' -url $url -options $options;
}
