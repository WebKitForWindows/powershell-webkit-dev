# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs Visual Studio Build Tools 2015.

  .Description
  Downloads VS Build Tools and installs it silently on the host.

  .Parameter InstallationPath
  The location to install to.
#>
Function Install-VSBuildTools2015 {
    Param(
        [Parameter()]
        [AllowNull()]
        [string] $installationPath
    )

    $url = 'https://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe';

    $options = @(
        '/NoRestart',
        '/Silent'
    );

    if ($installationPath) {
        $options += ('/CustomInstallPath="{0}"' -f $installationPath);
    }

    Install-FromExe -Name 'VSBuildTools2015' -Url $url -Options $options -NoVerify;
}
