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

  .Parameter BuiltType
  The type of build to do.

  .Parameter InstallPath
  The root install path.

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
    [string] $installPath,
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
  $genArgs += ('-DCMAKE_INSTALL_PREFIX={0}' -f $installPath);

  $buildDir = Join-Path $path (Join-Path 'build' $buildType);

  $genArgs += $options;

  $genArgs += ('-B{0}' -f $buildDir);
  $genArgs += ('-H{0}' -f $path);

  # Create the generate call
  $genCall = ('cmake {0}' -f ($genArgs -Join ' '));

  Write-Host $genCall;
  Invoke-Expression $genCall

  # Create the build call
  $buildArgs += @('--build', $buildDir, '--target install');

  $buildCall = ('cmake {0}' -f ($buildArgs -Join ' '));

  Write-Host $buildCall;
  Invoke-Expression $buildCall;
}
