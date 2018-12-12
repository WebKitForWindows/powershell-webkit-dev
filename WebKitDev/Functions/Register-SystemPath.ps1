# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Registers a path on the host system.

  .Description
  Adds a path to the host system. This can be used when a developer dependency
  does not contain a Windows installer.

  .Parameter Path
  The path to add.

  .Example
    # Add ninja
    Register-Path -Path C:\ninja
#>
Function Register-SystemPath {
    Param(
        [Parameter(Mandatory)]
        [string] $path
    )

    if (!([System.IO.Path]::IsPathRooted($path))) {
        Write-Error 'All system path values need to be absolute';
        return;
    }

    Write-Host ('Adding {0} to the system path' -f $path);

    # Get current path from the registry
    $systemPathKey = 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment';
    $systemPath = (Get-ItemProperty -Path $systemPathKey -Name PATH).Path;
    Write-Debug ('Current path {0}' -f $systemPath);

    # Create and store new path in the registry
    $updatedPath = ('{0};{1}' -f $systemPath, $path);
    Write-Debug ('Updating path to {0}' -f $updatedPath);
    Set-ItemProperty -Path $systemPathKey -Name PATH -Value $updatedPath;

    # Update script's environment
    Update-ScriptPath;
}
