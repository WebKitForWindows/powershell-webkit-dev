# Copyright (c) 2026, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs the Swift toolchain for Windows.

  .Description
  Downloads the specified release of the Swift toolchain for Windows and
  installs it silently on the host. The installer places the toolchain under
  the user profile and updates the user PATH rather than the machine PATH, so
  the environment is refreshed from both targets before verifying. Compiling
  with Swift additionally requires the MSVC toolchain and Windows SDK.

  .Parameter Version
  The version of the Swift toolchain to install.

  .Example
    # Install 6.3.3
    Install-Swift -Version 6.3.3
#>
function Install-Swift {
    param(
        [Parameter(Mandatory)]
        [string]$version
    )

    $url = ('https://download.swift.org/swift-{0}-release/windows10/swift-{0}-RELEASE/swift-{0}-RELEASE-windows10.exe' -f $version);

    $options = @(
        '-q'
    );

    # Install-FromExe only refreshes the machine PATH before verifying, but the
    # Swift installer updates the user PATH, so skip the built-in verification.
    Install-FromExe -Name 'swift' -url $url -Options $options -NoVerify;

    # Refresh the PATH from both the machine and user targets so the newly
    # installed toolchain is resolvable, then verify.
    $env:PATH = @(
        [Environment]::GetEnvironmentVariable('PATH',[EnvironmentVariableTarget]::Machine),
        [Environment]::GetEnvironmentVariable('PATH',[EnvironmentVariableTarget]::User)
    ) -join ';';

    Write-Information -MessageData 'Verifying swift install ...' -InformationAction Continue;
    swift --version;
}
