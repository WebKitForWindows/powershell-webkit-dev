# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Downloads an installs a package from an archive format.

  .Description
  Downloads an archive of a package and installs it at the specified location.

  .Parameter Name
  The name of the package.

  .Parameter Url
  The URL to download from.

  .Parameter InstallationPath
  The path to install at.

  .Parameter NoVerify
  If set the installation is not verified by attempting to call an executable
  with the given name.
#>
Function Install-FromArchive {
  Param(
    [Parameter(Mandatory)]
    [string] $name,
    [Parameter(Mandatory)]
    [string] $url,
    [Parameter(Mandatory)]
    [string] $installationPath,
    [Parameter()]
    [switch] $noVerify = $false
  )

  $extension = [System.IO.Path]::GetExtension($url);
  $archivePath = Join-Path ([System.IO.Path]::GetTempPath()) ('{0}.{1}' -f $name, $extension);

  Write-Host ('Downloading {0} package from {1} ..' -f $name, $url);
  (New-Object System.Net.WebClient).DownloadFile($url, $archivePath);
  Write-Host ('Downloaded {0} bytes' -f (Get-Item $archivePath).length);

  Write-Host ('Unzipping {0} package ...' -f $name);
  Expand-7Zip -ArchiveFileName $archivePath -TargetPath $installationPath;

  if (!$noVerify) {
    Write-Host ('Verifying {0} install ...' -f $name);
    $verifyCommand = ('  {0} --version' -f $name);
    Write-Host $verifyCommand;
    Invoke-Expression $verifyCommand;
  }

  Write-Host ('Removing {0} package  ...' -f $name);
  Remove-Item $archivePath -Force;

  Write-Host ('{0} install complete.' -f $name);
}
