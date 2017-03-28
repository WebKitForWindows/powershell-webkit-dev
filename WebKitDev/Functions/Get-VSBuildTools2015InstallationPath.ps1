# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Retrieves the location of a Visual Studio Build Tools 2015 installation.

  .Description
  Returns the default path for a Visual Studio Build Tools 2015 installation.

  The path should be tested before using. No error checking is performed.
#>
Function Get-VSBuildTools2015InstallationPath {
  return 'C:\Program Files (x86)\Microsoft Visual Studio 14.0';
}
