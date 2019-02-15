# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs bison.

  .Description
  Downloads the specified release of bison and unzips it to the specified
  location on disk.

  Before installation `Register-SystemPath` should be used to add the install
  location to the system path.

  .Link Register-SystemPath

  .Parameter Version
  The version of bison to install.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install 2.4.1
    Install-Bison -Version 2.4.1 -InstallationPath C:\gnuwin32
#>
Function Install-Bison {
    Param(
        [Parameter(Mandatory)]
        [string] $version,
        [Parameter(Mandatory)]
        [string] $installationPath
    )

    $url = ('https://newcontinuum.dl.sourceforge.net/project/gnuwin32/bison/{0}/bison-{0}-bin.zip' -f $version);

    Install-FromArchive -Name 'bison' -Url $url -InstallationPath $installationPath -NoVerify;

    $depsUrl = ('https://newcontinuum.dl.sourceforge.net/project/gnuwin32/bison/{0}/bison-{0}-dep.zip' -f $version);

    Install-FromArchive -Name 'bison' -Url $depsUrl -InstallationPath $installationPath
}
