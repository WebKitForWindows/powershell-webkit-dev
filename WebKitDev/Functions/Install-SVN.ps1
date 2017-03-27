# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs TortoiseSVN.

  .Description
  Downloads the specified release of TortoiseSVN and installs it silently
  on the host.

  .Parameter Version
  The version of TortoiseSVN to install.

  .Parameter BuildNumber
  The corresponding build number.

  .Example
    # Install 1.9.5
    Install-SVN -Version 1.9.5 -BuildNumber 27581
#>
Function Install-SVN {
  Param(
    [Parameter(Mandatory)]
    [string] $version,
    [Parameter(Mandatory)]
    [string] $buildNumber
  )

  $url = ('https://downloads.sourceforge.net/project/tortoisesvn/{0}/Application/TortoiseSVN-{0}.{1}-x64-svn-1.9.5.msi' -f $version, $buildNumber);
  $installerPath = Join-Path ([System.IO.Path]::GetTempPath()) 'svn-install.msi';

  Write-Host ('Downloading SVN installer from {0} ..' -f $url);
  (New-Object System.Net.WebClient).DownloadFile($url, $installerPath);
  Write-Host ('Downloaded {0} bytes' -f (Get-Item $installerPath).length);

  $args = @(
    '/i',
    $installerPath,
    '/quiet',
    '/qn',
    'ADDLOCAL=CLI'
  );

  Write-Host 'Installing SVN ...';
  Write-Host ('msiexec {0}' -f ($args -Join ' '));

  Start-Process msiexec -Wait -ArgumentList $args;

  # Update path
  Update-ScriptPath;

  Write-Host 'Verifying SVN install ...';
  Write-Host '  svn --version'; svn --version;

  Write-Host 'Removing SVN installer ...';
  Remove-Item $installerPath -Force;

  Write-Host 'SVN install complete.';
}
