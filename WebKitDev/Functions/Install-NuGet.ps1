# Copyright (c) 2019, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs the NuGet package manager.

  .Description
  Downloads the specified release of NuGet and places it in the specified
  location on disk.

  Before installation `Register-SystemPath` should be used to add the install
  location to the system path.

  .Link Register-SystemPath

  .Parameter Version
  The version of NuGet to install.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install 5.3.1
    Install-NuGet -Version 5.3.1 -InstallationPath C:\NuGet
#>
Function Install-NuGet {
    Param(
        [Parameter(Mandatory)]
        [string] $version,
        [Parameter(Mandatory)]
        [string] $installationPath,
        [Parameter()]
        [switch] $noPath = $false
    )

    $url = ('https://dist.nuget.org/win-x86-commandline/v{0}/nuget.exe' -f $version);

    if (!$noPath) {
        # NuGet installs an exe in the root
        Register-SystemPath $installationPath;
    }

    Install-FromExeDownload `
        -Name 'nuget' `
        -Url $url `
        -InstallationPath $installationPath `
        -NoVerify:$noPath `
        -VersionOptions @();
}
