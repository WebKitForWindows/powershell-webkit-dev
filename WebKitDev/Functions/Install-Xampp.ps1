# Copyright (c) 2018, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Installs XAMPP.

  .Description
  Downloads the specified release of Ruby and installs it silently on the host.

  A silent install of XAMPP does not allow a path to be specified so the install
  will always be present at C:/xampp.

  .Parameter Version
  The version of XAMPP to install.

  .Example
    # Install 7.2.4.0
    Install-Xampp -Version 7.2.4.0
#>
function Install-Xampp {
    param(
        [Parameter(Mandatory)]
        [string]$version
    )

    $major,$minor,$patch,$build = $version.split('.')
    if (-not $build) {
        $build = '0'
    }

    if ($major -eq '7') {
        $toolchain = 'VC15';
    }
    else {
        $toolchain = 'VS16';
    }

    $url = ('https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/{0}.{1}.{2}/xampp-windows-x64-{0}.{1}.{2}-{3}-{4}-installer.exe' -f ($major,$minor,$patch,$build,$toolchain));

    $options = @(
        '--unattendedmodeui','none',
        '--mode','unattended',
        '--launchapps','0',
        '--disable-components','xampp_mysql,xampp_filezilla,xampp_mercury,xampp_tomcat,xampp_perl,xampp_phpmyadmin,xampp_webalizer,xampp_sendmail'
    );

    Install-FromExe -Name 'xampp' -url $url -Options $options -noVerify;
}
