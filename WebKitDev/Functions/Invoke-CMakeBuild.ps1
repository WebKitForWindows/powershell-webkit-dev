# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Invokes a CMake Build.

  .Description
  Powershell wrapper for calling a CMake build.

  .Parameter Path
  The path that contains the root CMakeLists.txt.

  .Parameter BuildPath
  The path to build at.

  .Parameter InstallationPath
  The root install path.

  .Parameter BuildType
  The type of build to do.

  .Parameter Platform
  The platform to build for.

  .Parameter Options
  Additional CMake options for the build.
#>
Function Invoke-CMakeBuild {
  Param(
    [Parameter(Mandatory)]
    [string] $path,
    [Parameter(Mandatory)]
    [string] $buildPath,
    [Parameter(Mandatory)]
    [string] $installationPath,
    [Parameter(Mandatory)]
    [ValidateSet('Release','Debug')]
    [string] $buildType = 'Release',
    [ValidateSet('ninja','vs2015','vs2017')]
    [string] $generator = 'ninja',
    [Parameter()]
    [AllowNull()]
    [string] $platform,
    [Parameter()]
    [string[]] $options = @()
  )

  # Select the generator
  $genArgs = @('-G')

  if ($generator -eq 'ninja') {
    $genArgs += 'Ninja';
  } elseif ($generator -eq 'vs2015') {
    $genArgs += @('"Visual Studio 14 2015"', 'Win64');
  } else {
    $genArgs += @('"Visual Studio 15 2017"', 'Win64');
  }

  # Add all arguments
  if ($platform) {
    $genArgs += ('-DCMAKE_SYSTEM_NAME={0}' -f $platform);
  }

  $genArgs += ('-DCMAKE_BUILD_TYPE={0}' -f $buildType);
  $genArgs += ('-DCMAKE_INSTALL_PREFIX={0}' -f $installationPath);
  $genArgs += ('-DCMAKE_PREFIX_PATH={0}' -f $installationPath);

  $genArgs += $options;

  $genArgs += ('-B{0}' -f $buildPath);
  $genArgs += ('-H{0}' -f $path);

  # Create the generate call
  $genCall = ('cmake {0}' -f ($genArgs -Join ' '));

  Write-Host $genCall;
  Invoke-Expression $genCall

  # Create the build call
  $buildArgs += @('--build', $buildPath, '--target', 'install');

  if ($generator -ne 'ninja') {
    $buildArgs += ('--config', $buildType)
  }

  $buildCall = ('cmake {0}' -f ($buildArgs -Join ' '));

  Write-Host $buildCall;
  Invoke-Expression $buildCall;
  $cmakeExitCode = $LASTEXITCODE;

  if ($cmakeExitCode -ne 0) {
    throw "CMake failed with code {0}" -f $cmakeExitCode
  }
}
