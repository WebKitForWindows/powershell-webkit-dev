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
    # Install 2.3.3
    Install-Ruby -Version 2.3.3
#>
Function Install-Ruby {
  Param(
    [Parameter(Mandatory)]
    [string] $version,
    [Parameter()]
    [AllowNull()]
    [string] $installationPath
  )

  $url = ('https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-{0}-x64.exe' -f $version);

  $options = @(
    '/verysilent',
    '/tasks="assocfiles,modpath"'
  );

  if ($installationPath) {
    $options += ('/dir="{0}"' -f $installationPath);
  }

  Install-FromExe -Name 'ruby' -Url $url -Options $options;
}
