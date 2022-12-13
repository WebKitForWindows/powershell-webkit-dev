# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Selects and initializes the Visual Studio environment for use.

  .Description
  Initializes Visual Studio and Ninja builds. If a version is not specified it
  will search for a compatible environment.

  .Parameter Architecture
  The architecture to target.

  .Parameter Version
  The Visual Studio version to use. Either `vs2015` or `vs2017`. If not the
  value is not specified then the script will look for a compatible environment.
#>
function Select-VSEnvironment {
    param(
        [ValidateSet('x86','amd64')]
        [string]$architecture = 'amd64',
        [ValidateSet('vs2015','vs2017','vs2019','vs2022')]
        [AllowNull()]
        [string]$version
    )

    # Find version if not specified
    if (!$version) {
        if (Test-Path (Get-VSBuildTools2022InstallationPath)) {
            Write-Information -MessageData 'Found VS2022 Build Tools' -InformationAction Continue;
            $version = 'vs2022';
        }
        elseif (Test-Path (Get-VSBuildTools2019InstallationPath)) {
            Write-Information -MessageData 'Found VS2019 Build Tools' -InformationAction Continue;
            $version = 'vs2019';
        }
        elseif (Test-Path (Get-VSBuildTools2017InstallationPath)) {
            Write-Information -MessageData 'Found VS2017 Build Tools' -InformationAction Continue;
            $version = 'vs2017';
        }
        elseif (Test-Path (Get-VSBuildTools2015InstallationPath)) {
            Write-Information -MessageData 'Found VS2015 Build Tools' -InformationAction Continue;
            $version = 'vs2015';
        }
        else {
            Write-Error 'Could not find a compatible Visual Studio instance' -ErrorAction Stop;
        }
    }

    # Get vcvarsall.bat path
    $vcvars = $null;

    if ($version -eq 'vs2022') {
        $vcvars = Get-VSBuildTools2022VCVarsAllPath;
    }
    elseif ($version -eq 'vs2019') {
        $vcvars = Get-VSBuildTools2019VCVarsAllPath;
    }
    elseif ($version -eq 'vs2017') {
        $vcvars = Get-VSBuildTools2017VCVarsAllPath;
    }
    else {
        $vcvars = Get-VSBuildTools2015VCVarsAllPath;
    }

    Write-Information -MessageData $vcvars -InformationAction Continue;

    if (!(Test-Path $vcvars)) {
        Write-Error ('Could not find {0}' -f $vcvars) -ErrorAction Stop;
    }

    Initialize-VSEnvironment -architecture $architecture -Path $vcvars;

    # Initialize ninja
    $compilerExe = 'cl.exe';
    $compilerPath = (Get-Command $compilerExe).Path;

    Write-Information -MessageData ('Found compiler at {0}' -f $compilerPath) -InformationAction Continue;

    Initialize-NinjaEnvironment -Cc $compilerPath -cxx $compilerPath;
}
