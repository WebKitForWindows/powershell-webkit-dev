# Copyright (c) 2017, the WebKit for Windows project authors.  Please see the
# AUTHORS file for details. All rights reserved. Use of this source code is
# governed by a BSD-style license that can be found in the LICENSE file.

<#
  .Synopsis
  Downloads an installs a package from an archive format.

  .Description
  Downloads an archive of a package and installs it at the specified location.

  .Parameter Name
  The name of the package.

  .Parameter Url
  The URL to download from.

  .Parameter InstallationPath
  The path to install at.

  .Parameter ArchiveRoot
  The path within the archive to install.

  .Parameter NoVerify
  If set the installation is not verified by attempting to call an executable
  with the given name.
#>
Function Install-FromArchive {
    Param(
        [Parameter(Mandatory)]
        [string] $name,
        [Parameter(Mandatory)]
        [string] $url,
        [Parameter(Mandatory)]
        [string] $installationPath,
        [Parameter()]
        [AllowNull()]
        [string] $archiveRoot,
        [Parameter()]
        [switch] $noVerify = $false
    )

    $extension = [System.IO.Path]::GetExtension($url);
    $archivePath = Join-Path ([System.IO.Path]::GetTempPath()) ('{0}.{1}' -f $name, $extension);

    Write-Host ('Downloading {0} package from {1} ..' -f $name, $url);
    Invoke-WebFileRequest -Url $url -DestinationPath $archivePath;
    Write-Host ('Downloaded {0} bytes' -f (Get-Item $archivePath).length);

    # Expand to a temporary directory
    Write-Host ('Unzipping {0} package ...' -f $name);
    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid());
    Expand-7Zip -ArchiveFileName $archivePath -TargetPath $tempDir;
  
    # Get the archive root
    if ($archiveRoot) {
        $moveFrom = Join-Path $tempDir $archiveRoot;
    }
    else {
        $moveFrom = $tempDir;
    }

    Copy-DirectoryStructure -Path $moveFrom -Destination $installationPath;

    # Remove temporary directory and its contents
    Remove-Item $tempDir -Recurse -Force;

    if (!$noVerify) {
        Write-Host ('Verifying {0} install ...' -f $name);
        $verifyCommand = ('  {0} --version' -f $name);
        Write-Host $verifyCommand;
        Invoke-Expression $verifyCommand;
    }

    Write-Host ('Removing {0} package  ...' -f $name);
    Remove-Item $archivePath -Force;

    Write-Host ('{0} install complete.' -f $name);
}

Function Copy-DirectoryStructure {
    Param(
        [Parameter(Mandatory)]
        [string] $path,
        [Parameter(Mandatory)]
        [string] $destination
    )

    # Create destination path if necessary
    if (!(Test-Path $destination)) {
        New-Item $destination -ItemType directory | Out-Null;
    }

    # Iterate through directories
    $directories = Get-ChildItem $path -Dir;

    foreach ($dir in $directories) {
        $fromPath = Join-Path $path $dir.Name;
        $toPath = Join-Path $destination $dir.Name;

        Copy-DirectoryStructure -Path $fromPath -Destination $toPath;
    }

    # Iterate through files
    $files = Get-ChildItem $path -File;

    foreach ($file in $files) {
        Copy-Item -Path $file.FullName -Destination $destination;
    }
}
