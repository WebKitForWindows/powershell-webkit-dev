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

    Write-Information -MessageData 'Removing temporary files' -InformationAction Continue;
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
            Write-Information -MessageData ('All files have been removed') -InformationAction Continue;
            break;
        }

        Write-Information -MessageData ('Could not remove {0} files from temporary directories' -f $couldNotRemove.Count) -InformationAction Continue;

        # Break out of the loop after all attempts are exhausted
        if ($attempts -eq $maxAttempts) {
            break;
        }

        Write-Information -MessageData ('Waiting {0} seconds till next attempt' -f $sleepFor) -InformationAction Continue;
        Start-Sleep -Seconds $sleepFor;

        $attempts += 1;
        $sleepFor *= $sleepMultiplier;
        Write-Information -MessageData ('Attempt {0} of {1}' -f $attempts,$maxAttempts) -InformationAction Continue;
    }

    Write-Information -MessageData ('Removed {0} files from temporary directories' -f $filesRemoved) -InformationAction Continue;
}
