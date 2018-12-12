# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Removes temporary files.

  .Example
    Remove-TempFiles
#>
Function Remove-TempFiles {
    $tempFolders = @($env:temp, 'C:/Windows/temp')

    Write-Host 'Removing temporary files';
    $filesRemoved = 0;
  
    foreach ($folder in $tempFolders) {
        $files = Get-ChildItem -Recurse -Force -ErrorAction SilentlyContinue $folder;

        foreach ($file in $files) {
            try {
                Remove-Item $file.FullName -Recurse -Force -ErrorAction Stop
                $filesRemoved++;
            }
            catch {
                Write-Host ('Could not remove file {0}' -f $file.FullName)
            }
        }
    }

    Write-Host ('Removed {0} files from temporary directories' -f $filesRemoved)
}
