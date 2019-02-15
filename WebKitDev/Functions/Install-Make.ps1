# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs make.

  .Description
  Downloads the specified release of make and unzips it to the specified
  location on disk.

  Before installation `Register-SystemPath` should be used to add the install
  location to the system path.

  .Link Register-SystemPath

  .Parameter Version
  The version of make to install.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install 3.81
    Install-Make -Version 3.81 -InstallationPath C:\gnuwin32
#>
Function Install-Make {
    Param(
        [Parameter(Mandatory)]
        [string] $version,
        [Parameter(Mandatory)]
        [string] $installationPath
    )

    $url = ('https://newcontinuum.dl.sourceforge.net/project/gnuwin32/make/{0}/make-{0}-bin.zip' -f $version);

    Install-FromArchive -Name 'make' -Url $url -InstallationPath $installationPath -NoVerify;

    $depsUrl = ('https://newcontinuum.dl.sourceforge.net/project/gnuwin32/make/{0}/make-{0}-dep.zip' -f $version);

    Install-FromArchive -Name 'make' -Url $depsUrl -InstallationPath $installationPath  
}
