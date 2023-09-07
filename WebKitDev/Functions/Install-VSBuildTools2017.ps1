# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs Visual Studio Build Tools 2017.

  .Description
  Downloads VS Build Tools and installs it silently on the host.

  .Parameter InstallationPath
  The location to install to.
#>
function Install-VSBuildTools2017 {
    param(
        [Parameter()]
        [string[]]$workloads = @('Microsoft.VisualStudio.Workload.VCTools'),
        [Parameter()]
        [AllowNull()]
        [string]$installationPath
    )

    $url = 'https://aka.ms/vs/15/release/vs_buildtools.exe';

    $options = @(
        '--quiet',
        '--norestart',
        '--nocache',
        '--wait'
    );

    foreach ($workload in $workloads) {
        $options += @('--add',$workload);
    }

    if ($installationPath) {
        $options += @('--installPath',$installationPath);
    }

    Install-FromExe -Name 'VSBuildTools2017' -url $url -Options $options -noVerify;
}
