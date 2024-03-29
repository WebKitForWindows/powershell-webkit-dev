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
function Install-FromArchive {
    param(
        [Parameter(Mandatory)]
        [string]$name,
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter(Mandatory)]
        [string]$installationPath,
        [Parameter()]
        [AllowNull()]
        [string]$archiveRoot,
        [Parameter()]
        [switch]$noVerify = $false
    )

    $extension = [System.IO.Path]::GetExtension($url);
    $archivePath = Join-Path ([System.IO.Path]::GetTempPath()) ('{0}.{1}' -f $name,$extension);

    Write-Information -MessageData ('Downloading {0} package from {1} ..' -f $name,$url) -InformationAction Continue;
    Invoke-WebFileRequest -url $url -DestinationPath $archivePath;
    Write-Information -MessageData ('Downloaded {0} bytes' -f (Get-Item $archivePath).Length) -InformationAction Continue;
    Write-Information -MessageData ('Unzipping {0} package ...' -f $name) -InformationAction Continue;

    # Determine where to expand the archive to
    #
    # If there's an archive root we unzip to a temporary folder and then use
    # that.
    if ($archiveRoot) {
        $expandTo = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid());
        Write-Debug ('Archive root {0} specified, creating temp directory at {1}' -f $archiveRoot,$expandTo)
    }
    else {
        $expandTo = $installationPath;
    }

    Expand-SourceArchive -Path $archivePath -DestinationPath $expandTo;

    if ($archiveRoot) {
        Move-DirectoryStructure (Join-Path $expandTo $archiveRoot) $installationPath;
        Write-Debug ('Removing temporary directory {0}' -f $expandTo)
    }

    if (!$noVerify) {
        Write-Information -MessageData ('Verifying {0} install ...' -f $name) -InformationAction Continue;
        $verifyCommand = ('  {0} --version' -f $name);
        Write-Information -MessageData $verifyCommand -InformationAction Continue;
        Invoke-Expression $verifyCommand;
    }

    Write-Information -MessageData ('Removing {0} package  ...' -f $name) -InformationAction Continue;
    Remove-Item $archivePath -Force;

    Write-Information -MessageData ('{0} install complete.' -f $name) -InformationAction Continue;
}

function Move-DirectoryStructure {
    param(
        [Parameter(Mandatory)]
        [string]$path,
        [Parameter(Mandatory)]
        [string]$destination
    )

    Write-Debug ('Moving directory from {0} to {1}' -f $path,$destination)

    # See if we can just move the directory
    if (!(Test-Path $destination)) {
        # See if we need to create the parent directory
        $parent = Split-Path -Path $destination;
        if (!(Test-Path $parent)) {
            Write-Debug ('Parent directory {0} not present, need to create before moving' -f $parent);
            New-Item -ItemType Directory -Path $parent -Force | Out-Null;
        }

        Write-Debug ('Destination {0} not present, will just move {1}' -f $destination,$path);
        Move-Item -Path $path -Destination $destination;
        return;
    }

    Write-Debug ('Populating {0} ' -f $destination)

    # Iterate through directories
    $directories = Get-ChildItem $path -Dir;

    foreach ($dir in $directories) {
        $fromPath = Join-Path $path $dir.Name;
        $toPath = Join-Path $destination $dir.Name;

        Move-DirectoryStructure -Path $fromPath -Destination $toPath;
    }

    # Iterate through files
    $files = Get-ChildItem $path -File;

    foreach ($file in $files) {
        Copy-Item -Path $file.FullName -Destination $destination;
        Write-Debug ('Copying {0}' -f $file.FullName)
    }
}
