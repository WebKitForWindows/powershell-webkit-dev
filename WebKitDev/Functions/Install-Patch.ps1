# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs patch.

  .Description
  Installs the latest version of patch provided by MSYS2.
#>
function Install-Patch {
    Install-FromPacman -Name 'patch'
}
