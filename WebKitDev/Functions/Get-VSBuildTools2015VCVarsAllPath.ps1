# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Retrieves the default location for `vcvarsall.bat` within Visual Studio Build
  Tools 2015.

  .Description
  Retrieves the location of a Visual Studio Build Tools 2015 install and
  appends the path to `vcvarsall.bat`.

  The path should be tested before attempting to call the executable. No error
  checking is performed.
#>
function Get-VSBuildTools2015VCVarsAllPath {
    return (Join-Path (Get-VSBuildTools2015InstallationPath) 'VC\vcvarsall.bat');
}
