# Copyright (c) 2026, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs ccache.

  .Description
  Downloads the specified release of ccache and installs it silently on the
  host.

  .Parameter Version
  The version of ccache to install.

  .Parameter InstallationPath
  The location to install to.

  .Example
    # Install 4.13.2
    Install-Ccache -Version 4.13.2
#>
function Install-Ccache {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter()]
        [AllowNull()]
        [string]$installationPath
    )

    $installerOptions = @();

    if ($installationPath) {
        $installerOptions += ('INSTALLDIR="{0}"' -f $installationPath);
    }

    Install-FromChoco `
         -Name 'ccache' `
         -Version $version `
         -InstallerOptions $installerOptions;
}
