# Copyright (c) 2021, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs Visual Studio Build Tools 2022.

  .Description
  Downloads VS Build Tools and installs it silently on the host.

  .Parameter InstallationPath
  The location to install to.
#>
Function Install-VSBuildTools2022 {
    Param(
        [Parameter()]
        [string[]] $workloads = @('Microsoft.VisualStudio.Workload.VCTools'),
        [Parameter()]
        [AllowNull()]
        [string] $installationPath
    )

    $url = 'https://aka.ms/vs/17/release/vs_BuildTools.exe';

    $options = @(
        '--quiet',
        '--norestart',
        '--nocache',
        '--wait'
    );

    foreach ($workload in $workloads) {
        $options += @('--add', $workload);
    }

    if ($installationPath) {
        $options += @('--installPath', $installationPath);
    }

    Install-FromExe -Name 'VSBuildTools2022' -Url $url -Options $options -NoVerify;
}