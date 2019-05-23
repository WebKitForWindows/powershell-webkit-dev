# Copyright (c) 2019, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs Windows 10 Software Development Kit.

  .Description
  Downloads Windows10SDK and installs it silently on the host.

  .Parameter Features
  The features to install.

  .Parameter InstallationPath
  The location to install to.
#>
Function Install-Windows10SDK {
    Param(
        [Parameter()]
        [AllowNull()]
        [string[]] $features,
        [Parameter()]
        [AllowNull()]
        [string] $installationPath
    )

    $url = "http://download.microsoft.com/download/E/1/F/E1F1E61E-F3C6-4420-A916-FB7C47FBC89E/standalonesdk/sdksetup.exe"

    $options = @(
        '/Quiet',
        '/NoRestart'
    )

    if ($features) {
        $options += '/Features', $features
    }

    if ($installationPath) {
        $options += '/installPath', $installationPath
    }

    Install-FromExe -Name 'Windows10SDK' -Url $url -Options $options -NoVerify
}
