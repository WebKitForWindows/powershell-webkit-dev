# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Removes temporary files.

  .Example
    Remove-TempFiles
#>
function Remove-TempFiles {
    $tempFolders = @($env:temp,'C:/Windows/temp')

    Write-Host 'Removing temporary files';
    $attempts = 1;
    $maxAttempts = 5;
    $filesRemoved = 0;
    $sleepFor = 1.0;
    $sleepMultiplier = 2.5;

    while ($true) {
        $couldNotRemove = @();

        foreach ($folder in $tempFolders) {
            $files = Get-ChildItem -Recurse -Force -ErrorAction SilentlyContinue $folder;

            foreach ($file in $files) {
                try {
                    Remove-Item $file.FullName -Recurse -Force -ErrorAction Stop;
                    $filesRemoved++;
                }
                catch {
                    $couldNotRemove += $file.FullName;
                }
            }
        }

        # Break out of the loop if there were no problems
        if ($couldNotRemove.Count -eq 0) {
            Write-Host ('All files have been removed');
            break;
        }

        Write-Host ('Could not remove {0} files from temporary directories' -f $couldNotRemove.Count)

        # Break out of the loop after all attempts are exhausted
        if ($attempts -eq $maxAttempts) {
            break;
        }

        Write-Host ('Waiting {0} seconds till next attempt' -f $sleepFor);
        Start-Sleep -Seconds $sleepFor;

        $attempts += 1;
        $sleepFor *= $sleepMultiplier;
        Write-Host ('Attempt {0} of {1}' -f $attempts,$maxAttempts);
    }

    Write-Host ('Removed {0} files from temporary directories' -f $filesRemoved)
}
