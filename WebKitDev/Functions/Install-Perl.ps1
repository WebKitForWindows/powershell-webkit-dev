# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs Strawberry Perl.

  .Description
  Downloads the specified release of Perl and installs it silently on the host.

  .Parameter Version
  The version of Perl to install.

  .Parameter InstallationPath
  The location to install to.

  .Example
    # Install 5.24.1.1
    Install-Perl -Version 5.24.1.1
#>
function Install-Perl {
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
         -Name 'strawberryperl' `
         -Version $version `
         -InstallerOptions $installerOptions `
         -VerifyExe 'perl';
}
