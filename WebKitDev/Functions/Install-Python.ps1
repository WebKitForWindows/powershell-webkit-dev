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
Function Install-Python {
    Param(
        [Parameter(Mandatory)]
        [string] $version,
        [Parameter(Mandatory)]
        [string] $pipVersion,
        [Parameter()]
        [AllowNull()]
        [string] $installationPath
    )

    $major, $minor, $patch = $version.split('.');

    if ($major -ne '2') {
        $pythonUrl = ('https://www.python.org/ftp/python/{0}/python-{0}-amd64.exe' -f $version);
        $getPip = 'https://bootstrap.pypa.io/get-pip.py';

        $options = @(
            '/quiet',
            'InstallAllUsers=1',
            'PrependPath=1',
            'AssociateFiles=0'
        );

        if ($installationPath) {
            $options += ('TargetDir="{0}"' -f $installationPath)
        }

        Install-FromExe -Name 'python' -Url $pythonUrl -Options $options;
    }
    else {
        $pythonUrl = ('https://www.python.org/ftp/python/{0}/python-{0}.amd64.msi' -f $version);
        $getPip = 'https://bootstrap.pypa.io/pip/2.7/get-pip.py';

        $options = @(
            'ALLUSERS=1',
            'ADDLOCAL=DefaultFeature,Extensions,TclTk,Tools,PrependPath'
        );

        if ($installationPath) {
            $options += ('TARGETDIR="{0}"' -f $installationPath);
        }

        Install-FromMsi -Name 'python' -Url $pythonUrl -Options $options;
    }

    # Install PIP
    $pipInstall = ('pip=={0}' -f $pipVersion);
    Write-Host ('Installing {0} from {1} ...' -f ($pipInstall, $getPip));

    Invoke-WebFileRequest -Url $getPip -DestinationPath 'get-pip.py';

    python get-pip.py $pipInstall;
    Remove-Item get-pip.py -Force;

    if ($major -eq '2') {
        # Install Visual Studio for Python 2.7
        $vcForPythonUrl = 'https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi';

        Install-FromMsi -Name 'VCForPython27' -Url $vcForPythonUrl -NoVerify;
    }
}
