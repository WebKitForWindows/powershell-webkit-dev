# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs Python.

  .Description
  Downloads the specified release of Python and installs it silently on the
  host. Additionally PIP and Visual C++ for Python are installed.

  .Parameter Version
  The version of Python to install.

  .Parameter PipVersion
  The version of pip (Pip Installs Python) to install.

  .Parameter InstallationPath
  The location to install to.

  .Example
    # Install 2.7.13 and PIP 9.0.1
    Install-Python -Version 2.7.13 -PipVersion
#>
function Install-Python {
    param(
        [Parameter(Mandatory)]
        [string]$version,
        [Parameter(Mandatory)]
        [string]$pipVersion,
        [Parameter()]
        [AllowNull()]
        [string]$installationPath
    )

    $major,$minor,$patch = $version.split('.');
    $packageParameters = @();

    if ($installationPath) {
        $packageParameters += ('/InstallDir:"{0}"' -f $installationPath)
    }

    if ($major -ne '2') {
        $name = ('python{0}{1}' -f $major,$minor);
        $getPip = 'https://bootstrap.pypa.io/get-pip.py';
    }
    else {
        $name = 'python2'
        $getPip = 'https://bootstrap.pypa.io/pip/2.7/get-pip.py';
    }

    # Install Python
    Install-FromChoco `
         -Name $name `
         -Version $version `
         -VerifyExe 'python' `
         -PackageParameters $packageParameters;

    # Install PIP
    $pipInstall = ('pip=={0}' -f $pipVersion);
    Write-Information -MessageData ('Installing {0} from {1} ...' -f ($pipInstall,$getPip)) -InformationAction Continue;

    $pipScript = Join-Path ([System.IO.Path]::GetTempPath()) 'get-pip.py';
    Invoke-WebFileRequest -url $getPip -DestinationPath $pipScript;

    python.exe $pipScript $pipInstall;
    Remove-Item $pipScript -Force;
}
