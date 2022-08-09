# Copyright (c) 2019, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs the Minio client manager.

  .Description
  Downloads the latest release of Minio Client and places it in the specified
  location on disk.

  .Parameter InstallationPath
  The path to install at.

  .Example
    # Install
    Install-MinioClient-InstallationPath C:\Minio
#>
function Install-MinioClient {
    param(
        [Parameter(Mandatory)]
        [string]$installationPath,
        [Parameter()]
        [switch]$noPath = $false
    )

    $url = 'https://dl.min.io/client/mc/release/windows-amd64/mc.exe';

    if (!$noPath) {
        # Minio Client installs an exe in the root
        Register-SystemPath $installationPath;
    }

    Install-FromExeDownload `
         -Name 'mc' `
         -url $url `
         -installationPath $installationPath `
         -NoVerify:$noPath `
         -versionOptions @('version');
}
