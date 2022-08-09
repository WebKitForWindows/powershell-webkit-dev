# Copyright (c) 2020, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Updates the registry values for XAMPP's python location.

  .Description
  Updates the registry values for XAMPP's python location.

  .Parameter PythonPath
  The location python was installed to.
#>
function Update-XamppPythonLocation {
    param(
        [Parameter(Mandatory)]
        [string]$pythonPath
    )

    if (-not (Test-Path 'HKCR:')) {
        New-PSDrive -PSProvider registry -Root 'HKEY_CLASSES_ROOT' -Name 'HKCR' | Out-Null;
    }

    $pythonExecutable = Join-Path $pythonPath 'python.exe';

    if (!(Test-Path $pythonExecutable)) {
        Write-Error ('python not found at {0}' -f $perlPath);
        return;
    }

    $registryValue = ('{0} -X utf8' -f $pythonExecutable);

    # Add python filetype value
    $registryPath = 'HKCR:\.py\Shell\ExecCGI\Command';
    $registryKey = '(Default)';

    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null;
    }

    Write-Information -MessageData ('Writing {0} : {1} at {2}' -f $registryKey,$registryValue,$registryPath) -InformationAction Continue;
    New-ItemProperty -Path $registryPath -Name $registryKey -PropertyType String -Value $registryValue -Force | Out-Null;
}
