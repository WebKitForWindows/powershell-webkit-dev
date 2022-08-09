# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Initializes the Visual Studio C++ environment.

  .Description
  Powershell wrapper for calling `vcvarsall.bat` and replicating the
  environment back to the powershell context.

  .Parameter Architecture
  The architecture to setup for. Either `x86` or `amd64`.

  .Parameter Path
  The path to `vcvarsall.bat`

  .Parameter Toolset
  The Visual Studio toolset to use. If unspecified the latest installed is
  used.

  .Example
    # Initialize VC++ 2019 environment.
    Initialize-VSEnvironment -Architecture amd64 -Path (Get-VSBuildTools2019VCVarsAllPath)

  .Example
    # Initialize VC++ 2017 environment.
    Initialize-VSEnvironment -Architecture amd64 -Path (Get-VSBuildTools2017VCVarsAllPath)

  .Example
    # Initialize VC++ 2015 environment.
    Initialize-VSEnvironment -Architecture amd64 -Path (Get-VSBuildTools2015VCVarsAllPath)
#>
function Initialize-VSEnvironment {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('x86','amd64')]
        [string]$architecture,
        [Parameter(Mandatory)]
        [string]$path,
        [Parameter()]
        [AllowNull()]
        [string]$toolset
    )

    if (!(Test-Path $path)) {
        Write-Error ('{0} path not found.' -f $path);
        return;
    }

    $toolsetVersion = '';

    if ($toolset) {
        $toolsetVersion = ('-vcvars_ver={0}' -f $toolset);
    }

    # Taken from https://www.safaribooksonline.com/library/view/windows-powershell-cookbook/9780596528492/ch01s09.html
    $tempFile = [IO.Path]::GetTempFileName();

    # Store the output of cmd.exe. We also ask cmd.exe to output
    # the environment table after the batch file completes
    $call = ('"{0}" {1} {2} && set > "{3}"' -f $path,$architecture,$toolsetVersion,$tempFile);
    cmd.exe /c $call;

    # Go through the environment variables in the temp file.
    # For each of them, set the variable in our local environment.
    Get-Content $tempFile | ForEach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            Set-Content "env:\$($matches[1])" $matches[2]
        }
    }

    Remove-Item $tempFile;
}
