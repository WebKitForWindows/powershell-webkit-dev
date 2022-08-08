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
function Install-Nasm {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter(Mandatory)]
        [string]$installationPath,
        [Parameter()]
        [switch]$noPath = $false
    )

    $url = ('http://www.nasm.us/pub/nasm/releasebuilds/{0}/win64/nasm-{0}-win64.zip' -f $version);

    if (!$noPath) {
        # Nasm installs an exe in the root
        Register-SystemPath $installationPath;
    }

    Install-FromArchive -Name 'nasm' -url $url -installationPath $installationPath -archiveRoot ("nasm-{0}" -f $version) -NoVerify:$noPath;
}
