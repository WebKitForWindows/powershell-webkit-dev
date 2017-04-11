# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs the Ninja build system.

  .Description
  Downloads the specified release of Ninja and unzips it to the specified
  location on disk.

  Before installation `Register-SystemPath` should be used to add the install
  location to the system path.

  .Link Register-SystemPath

  .Parameter Version
  The version of Ninja to install.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install 1.7.2
    Install-Ninja -Version 1.7.2 -InstallationPath C:\Ninja
#>
Function Install-Ninja {
  Param(
    [Parameter(Mandatory)]
    [string] $version,
    [Parameter(Mandatory)]
    [string] $installationPath
  )

  $url = ('https://github.com/ninja-build/ninja/releases/download/v{0}/ninja-win.zip' -f $version);

  Install-FromArchive -Name 'ninja' -Url $url -InstallationPath $installationPath;
}
