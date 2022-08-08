# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Updates the registry values for XAMPP's perl location.

  .Description
  Updates the registry values for XAMPP's perl location. By default XAMPP is
  not installed with perl support since perl will already be present in a
  WebKit development environment.

  .Parameter PerlPath
  The location perl was installed to.
#>
function Update-XamppPerlLocation {
    param(
        [Parameter(Mandatory)]
        [string]$perlPath
    )

    if (-not (Test-Path 'HKCR:')) {
        New-PSDrive -PSProvider registry -Root 'HKEY_CLASSES_ROOT' -Name 'HKCR' | Out-Null;
    }

    $perlExecutable = Join-Path $perlPath (Join-Path 'perl' (Join-Path 'bin' 'perl.exe'));

    if (!(Test-Path $perlExecutable)) {
        Write-Error ('perl not found at {0}' -f $perlPath);
        return;
    }

    $registryValue = ('{0} -T' -f $perlExecutable);

    # Add perl filetype value
    $registryPath = 'HKCR:\.pl\Shell\ExecCGI\Command';
    $registryKey = '(Default)';

    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null;
    }

    Write-Host ('Writing {0} : {1} at {2}' -f $registryKey,$registryValue,$registryPath);
    New-ItemProperty -Path $registryPath -Name $registryKey -PropertyType String -Value $registryValue -Force | Out-Null;

    # Add CGI filetype value
    $registryPath = 'HKCR:\.cgi\Shell\ExecCGI\Command';
    $registryKey = '(Default)';

    if (!(Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null;
    }

    Write-Host ('Writing {0} : {1} at {2}' -f $registryKey,$registryValue,$registryPath);
    New-ItemProperty -Path $registryPath -Name $registryKey -PropertyType String -Value $registryValue -Force | Out-Null;
}
