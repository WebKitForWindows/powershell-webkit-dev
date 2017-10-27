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
Function Install-Ruby {
  Param(
    [Parameter(Mandatory)]
    [string] $version,
    [Parameter()]
    [AllowNull()]
    [string] $installationPath
  )

  $url = ('https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-{0}/rubyinstaller-{0}-x64.exe' -f $version);
  
  $options = @(
    '/verysilent',
    '/tasks="assocfiles,modpath"'
  );

  if ($installationPath) {
    $options += ('/dir="{0}"' -f $installationPath);
  }

  Install-FromExe -Name 'ruby' -Url $url -Options $options;
}
