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

    # Expand to a temporary directory
    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid());

    Expand-7Zip -ArchiveFileName $path -TargetPath $tempDir;

    # Look at the contents of the temporary directory to see if another file
    # should be expanded.
    #
    # This check is for tar.gz type archives.
    $contents = (Get-ChildItem $tempDir)[0];
    $expandedPath = $contents.FullName;

    if ($contents -is [System.IO.DirectoryInfo]) {
        Move-Item -Path $expandedPath -Destination $destinationPath;
    }
    else {
        Expand-SourceArchive -Path $expandedPath -DestinationPath $destinationPath;
    }

    # Remove temporary directory and its contents
    Remove-Item $tempDir -Recurse -Force;
}
