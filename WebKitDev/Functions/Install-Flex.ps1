# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs flex.

  .Description
  Installs the latest version of flex provided by MSYS2.
#>
function Install-Flex {
    Install-FromPacman -Name 'flex';
}
