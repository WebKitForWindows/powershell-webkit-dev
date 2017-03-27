# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs Git for Windows.

  .Description
  Downloads the specified release of Git for Windows and installs it silently
  on the host.

  .Parameter Version
  The version of Git for Windows to install.

  .Parameter BuildNumber
  The corresponding build number.

  .Example
    # Install 2.12.1
    Install-Git -Version 2.12.1 -BuildNumber 1
#>
Function Install-Git {
  Param(
    [Parameter(Mandatory)]
    [string] $version,
    [Parameter(Mandatory)]
    [string] $buildNumber
  )

  $url = ('https://github.com/git-for-windows/git/releases/download/v{0}.windows.{1}/Git-{0}-64-bit.exe' -f $version, $buildNumber);

  $options = @(
    '/VERYSILENT',
    '/SUPPRESSMSGBOXES',
    '/NORESTART',
    '/NOCANCEL',
    '/SP-',
    '/COMPONENTS=Cmd'
  );

  Install-FromExe -Name 'git' -Url $url -Options $options;
}
