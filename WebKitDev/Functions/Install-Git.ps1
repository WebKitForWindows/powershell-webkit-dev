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

  .Parameter InstallationPath
  The location to install to.

  .Example
    # Install 2.12.1.1
    Install-Git -Version 2.12.1.1
#>
function Install-Git {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter()]
        [AllowNull()]
        [string]$installationPath
    )

    $major,$minor,$patch,$build = $version.split('.');

    if ($build -ne '1') {
        $exePath = ('Git-{0}.{1}.{2}.{3}-64-bit.exe' -f $major,$minor,$patch,$build);
    }
    else {
        $exePath = ('Git-{0}.{1}.{2}-64-bit.exe' -f $major,$minor,$patch);
    }

    $url = ('https://github.com/git-for-windows/git/releases/download/v{0}.{1}.{2}.windows.{3}/{4}' -f $major,$minor,$patch,$build,$exePath);

    $options = @(
        '/VERYSILENT',
        '/SUPPRESSMSGBOXES',
        '/NORESTART',
        '/NOCANCEL',
        '/SP-',
        '/COMPONENTS=Cmd'
    );

    if ($installationPath) {
        $options += ('/DIR="{0}"' -f $installationPath);
    }

    Install-FromExe -Name 'git' -url $url -Options $options;
}
