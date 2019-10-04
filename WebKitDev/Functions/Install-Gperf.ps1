# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs gperf.

  .Description
  Installs the latest version of gperf provided by MSYS2.
#>
Function Install-Gperf {
    Install-FromPacman -Name 'gperf'
}
