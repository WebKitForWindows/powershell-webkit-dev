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

  .Parameter InstallationPath
  The location to install to.

  .Example
    # Install 1.9.5.27581
    Install-SVN -Version 1.9.5.27581
#>
function Install-SVN {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter()]
        [AllowNull()]
        [string]$installationPath
    )

    $major,$minor,$patch,$build = $version.split('.');

    $url = ('https://mirrors.gigenet.com/OSDN/storage/g/t/to/tortoisesvn/{0}.{1}.{2}/Application/TortoiseSVN-{0}.{1}.{2}.{3}-x64-svn-{0}.{1}.{2}.msi' -f $major,$minor,$patch,$build);

    $options = @(
        'ADDLOCAL=CLI'
    );

    if ($installationPath) {
        $options += ('INSTALLDIR="{0}"' -f $installationPath);
    }

    Install-FromMsi -Name 'svn' -url $url -Options $options;
}
