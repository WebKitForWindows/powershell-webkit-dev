# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs make.

  .Description
  Installs the latest version of make provided by MSYS2.
#>
function Install-Make {
    Install-FromPacman -Name 'make'
}
