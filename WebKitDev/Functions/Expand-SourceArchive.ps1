# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Expands a source code archive.

  .Description
  Recursively expands a source code archive and moves it to the destination
  path. Source code releases typically archive a folder. They may also use tar
  as well as compression. This script handles these cases.

  .Parameter Path
  The path to the archive.

  .Parameter DestinationPath
  The path to expand to.

  .Example
    Expand-SourceArchive -Path foo.tar.gz -DestinationPath C:\foo.
#>
Function Expand-SourceArchive {
    Param(
        [Parameter(Mandatory)]
        [string] $path,
        [Parameter(Mandatory)]
        [string] $destinationPath
    )

    Write-Debug ('Getting information for archive {0}' -f $path);
    $files = Get-7Zip -ArchiveFileName $path;
    $fileCount = $files.Count;
    Write-Debug ('Archive contains {0} files' -f $fileCount);

    # Determine if a nested call extraction is required
    $tempDir = '';
    if ($fileCount -eq 1 -And $files[0].FileName -eq '[no name]') {
        # Expand to a temporary directory
        $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid());
        Write-Debug ('Expanding nested archive to {0}' -f $tempDir);
        Expand-7Zip -ArchiveFileName $path -TargetPath $tempDir;

        # Get new path
        $path = (Get-ChildItem $tempDir)[0].FullName;
    }

    Write-Debug ('Expanding archive {0} to {1}' -f $path, $destinationPath);
    Expand-7Zip -ArchiveFileName $path -TargetPath $destinationPath;

    # Remove temporary directory and its contents if necessary
    if ($tempDir -ne '') {
        Write-Debug ('Removing temp directory {0}' -f $tempDir)
        Remove-Item $tempDir -Recurse -Force;
    }
}
