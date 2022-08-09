# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Downloads an installs a font.

  .Parameter Url
  The URL to download from.
#>
function Install-Font {
    param(
        [Parameter(Mandatory)]
        [string]$url
    )

    $filename = [System.IO.Path]::GetFilename($url);
    $fontPath = Join-Path ([System.IO.Path]::GetTempPath()) $filename;

    Write-Information -MessageData ('Downloading {0} font from {1} ..' -f $name,$url) -InformationAction Continue;
    Invoke-WebFileRequest -url $url -DestinationPath $fontPath;
    Write-Information -MessageData ('Downloaded {0} bytes' -f (Get-Item $fontPath).Length) -InformationAction Continue;

    # Retrieve the font's name
    if (-not ('System.Drawing.Text.PrivateFontCollection' -as [type])) {
        Add-Type -AssemblyName System.Drawing;
    }

    $fontCollection = New-Object System.Drawing.Text.PrivateFontCollection;
    $fontCollection.AddFontFile($fontPath);
    $fontName = $fontCollection.Families.Name;

    Write-Information -MessageData ('Installing font {0} from {1}' -f $fontName,$filename) -InformationAction Continue;

    # Move the file to the correct location
    $shell = New-Object -ComObject Shell.Application;
    $fonts = $shell.Namespace(0x14);
    $installationPath = $fonts.Self.Path;

    Write-Information -MessageData ('Installing at {0}' -f $installationPath) -InformationAction Continue;

    $fonts.CopyHere($fontPath);

    # Font suffixes when creating the registry key
    $fontSuffix = @{
        '.fon' = ''
        '.fnt' = ''
        '.ttf' = ' (TrueType)'
        '.ttc' = ' (TrueType)'
        '.otf' = ' (OpenType)'
    }

    # Add the font to the registry
    $registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts';
    $registryKey = ('{0}{1}' -f $fontName,$fontSuffix[[System.IO.Path]::GetExtension($filename)]);
    $registryTest = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue;

    if (-not ($registryTest)) {
        Write-Information -MessageData ('Writing {0} : {1} at ${2}' -f $registryKey,$filename,$registryPath) -InformationAction Continue;
        New-ItemProperty -Path $registryPath -Name $registryKey -PropertyType String -Value $filename | Out-Null;
    }
    else {
        Write-Information -MessageData 'Font already present in registry' -InformationAction Continue;
        Write-Information -MessageData ('Value {0} : {1} at ${2}' -f $registryKey,$registryTest.$registryKey,$registryPath) -InformationAction Continue;
    }

    # Verify that the font is present
    Get-Font $name;

    # Cleanup the temp directory
    Remove-TempFiles;
}
