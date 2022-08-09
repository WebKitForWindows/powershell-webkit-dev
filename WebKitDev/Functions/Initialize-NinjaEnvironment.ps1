# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Initializes the Ninja build environment.

  .Description
  Powershell command to set the environment variables expected for a Ninja
  build.

  .Parameter CC
  The path to the C compiler.

  .Parameter CXX
  The path to the C++ compiler.
#>
function Initialize-NinjaEnvironment {
    param(
        [Parameter(Mandatory)]
        [string]$cc,
        [Parameter(Mandatory)]
        [string]$cxx
    )

    $env:CC = $cc;
    $env:CXX = $cxx;
}
