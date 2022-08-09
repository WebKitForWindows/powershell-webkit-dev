param(
    [string]$nugetApiKey
)

$ErrorActionPreference = 'Stop';

if (-not ($nugetApiKey)) {
    $nugetApiKey = $Env:NUGET_API_KEY;

    if (-not ($nugetApiKey)) {
        Write-Error 'API key is not specified on command line or in Env:NUGET_API_KEY';
    }
}

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted;

# Need to install the modules otherwise the tests will fail
if (-not (Get-Module -Name '7Zip4Powershell')) {
    Write-Information -MessageData 'Installing 7Zip4Powershell dependency' -InformationAction Continue;
    Install-Module -Name '7Zip4Powershell' -RequiredVersion 1.13.0 -Force;
}

if (-not (Get-Module -Name 'VSSetup')) {
    Write-Information -MessageData 'Installing VSSetup dependency' -InformationAction Continue;
    Install-Module -Name 'VSSetup' -RequiredVersion 2.2.16 -Force;
}

Write-Information -MessageData 'Publishing WebKitDev package' -InformationAction Continue;
Publish-Module -Path (Join-Path $PSScriptRoot WebKitDev) -NuGetApiKey $nugetApiKey -Force;
