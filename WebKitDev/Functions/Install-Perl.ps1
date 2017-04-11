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
Function Install-Perl {
  Param(
    [Parameter(Mandatory)]
    [string] $version,
    [Parameter()]
    [AllowNull()]
    [string] $installationPath
  )

  $url = ('http://strawberryperl.com/download/{0}/strawberry-perl-{0}-64bit.msi' -f $version);

  $options = @();

  if ($installationPath) {
    $options += ('INSTALLDIR="{0}"' -f $installationPath);
  }

  Install-FromMsi -Name 'perl' -Url $url -Options $options;
}
