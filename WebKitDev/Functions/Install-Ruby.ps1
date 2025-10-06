# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs Ruby.

  .Description
  Downloads the specified release of Ruby and installs it silently on the host.

  .Parameter Version
  The version of Ruby to install.

  .Parameter InstallationPath
  The location to install to.

  .Example
    # Install 2.4.2-2
    Install-Ruby -Version 2.4.2-2
#>
function Install-Ruby {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter()]
        [AllowNull()]
        [string]$installationPath
    )
    $packageParameters = @();

    if ($installationPath) {
        $packageParameters += ('/InstallDir:"{0}"' -f $installationPath);
    }

    Install-FromChoco `
         -Name 'ruby' `
         -Version $version `
         -PackageParameters $packageParameters;
}
