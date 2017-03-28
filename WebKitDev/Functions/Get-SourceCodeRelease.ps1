# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Retrieves the source code for a project.

  .Parameter Name
  The name of the source code package.

  .Parameter Path
  The path to the source code release.

  .Parameter DestinationPath
  The location to expand the source code to.
#>
Function Get-SourceCodeRelease {
  Param(
    [Parameter(Mandatory)]
    [string] $name,
    [Parameter(Mandatory)]
    [string] $path,
    [Parameter(Mandatory)]
    [string] $destinationPath
  )

  Write-Host ('Downloading {0} source code from {1} ...' -f $name, $path);
  $extension = [System.IO.Path]::GetExtension($path);
  $fileName = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName { $_ -replace '.tmp$', $extension } -PassThru;
  (New-Object System.Net.WebClient).DownloadFile($path, $fileName);
  Write-Host ('Downloaded {0} bytes' -f (Get-Item $fileName).Length);

  Write-Host ('Unzipping {0} source code to {1} ...' -f $name, $destinationPath);
  Expand-SourceArchive -Path $fileName -DestinationPath $destinationPath;

  # Clean up temporary files
  Remove-Item $fileName -Force;

  Write-Host 'Complete';
}
