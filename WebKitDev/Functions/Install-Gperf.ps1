# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs gperf.

  .Description
  Downloads the specified release of gperf and unzips it to the specified
  location on disk.

  Before installation `Register-SystemPath` should be used to add the install
  location to the system path.

  .Link Register-SystemPath

  .Parameter Version
  The version of gperf to install.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install 3.0.1
    Install-Gperf -Version 3.0.1 -InstallationPath C:\gnuwin32
#>
function Install-Gperf {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter(Mandatory)]
        [string]$installationPath
    )

    $url = ('https://newcontinuum.dl.sourceforge.net/project/gnuwin32/gperf/{0}/gperf-{0}-bin.zip' -f $version);

    Install-FromArchive -Name 'gperf' -url $url -installationPath $installationPath;
}
