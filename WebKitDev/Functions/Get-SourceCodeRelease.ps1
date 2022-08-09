# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Retrieves the source code for a project.

  .Parameter Name
  The name of the source code package.

  .Parameter Url
  The path to the source code release.

  .Parameter DestinationPath
  The location to expand the source code to.
#>
function Get-SourceCodeRelease {
    param(
        [Parameter(Mandatory)]
        [string]$name,
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter(Mandatory)]
        [string]$destinationPath
    )

    Write-Information -MessageData ('Downloading {0} source code from {1} ...' -f $name,$url) -InformationAction Continue;
    $extension = [System.IO.Path]::GetExtension($url);
    $fileName = [System.IO.Path]::GetTempFileName() | Rename-Item -NewName { $_ -replace '.tmp$',$extension } -Passthru;
    Invoke-WebFileRequest -url $url -DestinationPath $fileName;
    Write-Information -MessageData ('Downloaded {0} bytes' -f (Get-Item $fileName).Length) -InformationAction Continue;

    Write-Information -MessageData ('Unzipping {0} source code to {1} ...' -f $name,$destinationPath) -InformationAction Continue;
    Expand-SourceArchive -Path $fileName -DestinationPath $destinationPath;

    # Clean up temporary files
    Remove-Item $fileName -Force;

    Write-Information -MessageData 'Complete' -InformationAction Continue;
}
