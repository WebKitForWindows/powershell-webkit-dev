# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs the Netwise Assembler.

  .Description
  Downloads the specified release of NASM and unzips it to the specified
  location on disk.

  Before installation `Register-SystemPath` should be used to add the install
  location to the system path.

  .Link Register-SystemPath

  .Parameter Version
  The version of NASM to install.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install 2.13.01
    Install-NASM -Version 2.13.01 -InstallationPath C:\Nasm
#>
Function Install-Nasm {
    Param(
        [Parameter(Mandatory)]
        [string] $version,
        [Parameter(Mandatory)]
        [string] $installationPath
    )

    $url = ('http://www.nasm.us/pub/nasm/releasebuilds/{0}/win64/nasm-{0}-win64.zip' -f $version);

    Install-FromArchive -Name 'nasm' -Url $url -InstallationPath $installationPath -ArchiveRoot ("nasm-{0}" -f $version);
}
