# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Retrieves the location of a Visual Studio Build Tools 2017 installation.

  .Description
  Interacts with Visual Studio Setup to find an instance of Visual Studio 2017.
  If not found the default path will be returned.

  The path should be tested before using. No error checking is performed.
#>
Function Get-VSBuildTools2017InstallationPath {
  $installs = Get-VSSetupInstance;

  foreach ($install in $installs) {
    if ($install.DisplayName -eq 'Visual Studio Build Tools 2017') {
      return $install.InstallationPath;
    }
  }

  # If the Build Tools are not found, try Enterprise, then Professional, and then Community.
  # These packages all contain the Build Tools as a component.
  foreach ($install in $installs) {
    if ($install.DisplayName -eq 'Visual Studio Enterprise 2017') {
      return $install.InstallationPath;
    }
  }

  foreach ($install in $installs) {
    if ($install.DisplayName -eq 'Visual Studio Professional 2017') {
      return $install.InstallationPath;
    }
  }

  foreach ($install in $installs) {
    if ($install.DisplayName -eq 'Visual Studio Community 2017') {
      return $install.InstallationPath;
    }
  }

  # Return the default path
  return 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools';
}
