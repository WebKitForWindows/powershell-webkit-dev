# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs bison.

  .Description
  Installs the latest version of bison provided by MSYS2.
#>
Function Install-Bison {
    Install-FromPacman -Name 'bison';
}
