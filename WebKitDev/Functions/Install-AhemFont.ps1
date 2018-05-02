# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs the AHEM font.

  .Description
  Downloads the AHEM font and installs it into the system fonts.

  The AHEM font is used for layout tests in WebKit and is retrieved from 
  https://github.com/w3c/web-platform-tests.
#>
Function Install-AhemFont {
  Install-Font -Url 'https://raw.githubusercontent.com/w3c/web-platform-tests/master/fonts/Ahem.ttf';
}
