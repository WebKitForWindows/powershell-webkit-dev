# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

# Taken from https://blogs.msdn.microsoft.com/mediaandmicrocode/2008/12/24/microcode-powershell-scripting-tricks-get-font/

<#
    .Synopsis
    Gets the fonts currently loaded on the system

    .Description
    Uses the type System.Windows.Media.Fonts static property SystemFontFamilies,
    to retrieve all of the fonts loaded by the system.  If the Fonts type is not found,
    the PresentationCore assembly will be automatically loaded.

    This unfortunately can only enumerate the fonts that are present when the assembly
    is loaded. This is because of how assemblys are loaded in Powershell. If the font
    expected is not present then try running in a new Powershell instance to verify
    that its present.

    .Parameter font
    A wildcard to search for font names

    .Example
    # Get All Fonts
    Get-Font

    .Example
    # Get All Lucida Fonts
    Get-Font *Lucida*
#>
Function Get-Font {
    Param(
        [Parameter()]
        $font = '*'
    )

    if (-not ("Windows.Media.Fonts" -as [Type])) {
        Add-Type -AssemblyName PresentationCore;
    }

    [Windows.Media.Fonts]::SystemFontFamilies | Where-Object { $_.Source -like $font };
}
