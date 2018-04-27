# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs diff utils.

  .Description
  Downloads the specified release of diff utils and unzips it to the specified
  location on disk.

  Before installation `Register-SystemPath` should be used to add the install
  location to the system path.

  .Link Register-SystemPath

  .Parameter Version
  The version of diff utils to install.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install 2.8.7.1
    Install-DiffUtils -Version 2.8.7.1 -InstallationPath C:\gnuwin32
#>
Function Install-DiffUtils {
  Param(
    [Parameter(Mandatory)]
    [string] $version,
    [Parameter(Mandatory)]
    [string] $installationPath
  )

  # There is a commandlet `diff` so use `diff3` as a check for success

  $major, $minor, $patch, $build = $version.split('.');

  $url = ('https://downloads.sourceforge.net/project/gnuwin32/diffutils/{0}.{1}.{2}-{3}/diffutils-{0}.{1}.{2}-{3}-bin.zip' -f $major, $minor, $patch, $build);

  Install-FromArchive -Name 'diff3' -Url $url -InstallationPath $installationPath -NoVerify;

  $depsUrl = ('https://downloads.sourceforge.net/project/gnuwin32/diffutils/{0}.{1}.{2}-{3}/diffutils-{0}.{1}.{2}-{3}-dep.zip' -f $major, $minor, $patch, $build);

  Install-FromArchive -Name 'diff3' -Url $depsUrl -InstallationPath $installationPath  
}
