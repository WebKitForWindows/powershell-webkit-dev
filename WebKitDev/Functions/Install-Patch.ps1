# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs patch.

  .Description
  Downloads the specified release of patch and unzips it to the specified
  location on disk.

  Before installation `Register-SystemPath` should be used to add the install
  location to the system path.

  .Link Register-SystemPath

  .Parameter Version
  The version of patch to install.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install 2.5.9
    Install-Patch -Version 2.5.9 -InstallationPath C:\gnuwin32
#>
Function Install-Patch {
    Param(
        [Parameter(Mandatory)]
        [string] $version,
        [Parameter(Mandatory)]
        [string] $installationPath
    )

    $url = ('https://newcontinuum.dl.sourceforge.net/project/gnuwin32/patch/{0}/patch-{0}-bin.zip' -f $version);

    Install-FromArchive -Name 'patch' -Url $url -InstallationPath $installationPath;
}
