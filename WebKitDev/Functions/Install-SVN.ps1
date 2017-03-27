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

  .Parameter BuildNumber
  The corresponding build number.

  .Example
    # Install 1.9.5
    Install-SVN -Version 1.9.5 -BuildNumber 27581
#>
Function Install-SVN {
  Param(
    [Parameter(Mandatory)]
    [string] $version,
    [Parameter(Mandatory)]
    [string] $buildNumber
  )

  $url = ('https://downloads.sourceforge.net/project/tortoisesvn/{0}/Application/TortoiseSVN-{0}.{1}-x64-svn-1.9.5.msi' -f $version, $buildNumber);

  $options = @(
    'ADDLOCAL=CLI'
  );

  Install-FromMsi -Name 'svn' -Url $url -Options $options;
}
