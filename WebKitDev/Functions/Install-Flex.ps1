# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs flex.

  .Description
  Downloads the specified release of flex and unzips it to the specified
  location on disk.

  Before installation `Register-SystemPath` should be used to add the install
  location to the system path.

  .Link Register-SystemPath

  .Parameter Version
  The version of flex to install.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install 2.5.4a-1
    Install-Flex -Version 2.5.4a-1 -InstallationPath C:\gnuwin32
#>
Function Install-Flex {
    Param(
        [Parameter(Mandatory)]
        [string] $version,
        [Parameter(Mandatory)]
        [string] $installationPath
    )

    $url = ('https://downloads.sourceforge.net/project/gnuwin32/flex/{0}/flex-{0}-bin.zip' -f $version);

    Install-FromArchive -Name 'flex' -Url $url -InstallationPath $installationPath;
}
