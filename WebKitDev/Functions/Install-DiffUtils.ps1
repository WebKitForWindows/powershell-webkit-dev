# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs diff utils.

  .Description
  Installs the latest version of diff utils provided by MSYS2.
#>
Function Install-DiffUtils {
    Install-FromPacman -Name 'diffutils' -VerifyExe 'diff3'
}
