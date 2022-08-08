param(
    [switch]$exitCodeOnFormat = $false,
    [string]$moduleRoot
)

$ErrorActionPreference = 'Stop';

# Import the PowerShell modules locally
if (-not ($moduleRoot)) {
    $moduleRoot = Join-Path $PSScriptRoot -ChildPath 'psmodules';
}

if (-not (Test-Path -Path $moduleRoot)) {
    New-Item -Path $moduleRoot -ItemType 'directory' | Out-Null;
}

function Import-ModuleLocally {
    param(
        [string]$name,
        [string]$version
    )

    Write-Information -MessageData ('Importing {0} v{1}' -f $name,$version) -InformationAction Continue;
    if (Get-Module -Name $name) {
        Remove-Module -Name $name;
    }

    $importModule = Join-Path $moduleRoot -ChildPath $name | `
         Join-Path -ChildPath $version | `
         Join-Path -ChildPath ($name + '.psd1');

    if (-not (Test-Path -Path $importModule)) {
        Write-Information -MessageData ('Saving module {0}' -f $name) -InformationAction Continue;
        Save-Module $name -Path $moduleRoot -Repository PSGallery -RequiredVersion $version;
    }

    Import-Module $importModule;
}

Import-ModuleLocally -Name PSScriptAnalyzer -Version 1.20.0;
Import-ModuleLocally -Name PowerShell-Beautifier -Version 1.2.5;

# Use Invoke-Formatter on all code
# Using -Exclude breaks the -Filter functionality so a regex using Where-Object is used instead
$psScripts = Get-ChildItem -Path $PSScriptRoot -Exclude 'psmodules' | `
     Get-ChildItem -Recurse | `
     Where-Object { $_.FullName -match '.*\.ps1$' }
$formatted = $false;

foreach ($script in $psScripts) {
    $scriptPath = $script.FullName;
    $initialHash = (Get-FileHash -Path $scriptPath).Hash;
    $contents = Get-Content -Raw -Path $scriptPath;

    # Use built-in PowerShell formatter
    $contents = Invoke-Formatter -ScriptDefinition $contents;
    Set-Content -Path $scriptPath -Value $contents.Trim();

    # Use the Powershell beautifier
    # It can't take a string input so have to use the file path
    Edit-DTWBeautifyScript -SourcePath $scriptPath -IndentType FourSpaces;
    $finalHash = (Get-FileHash -Path $scriptPath).Hash;

    if ($initialHash -ne $finalHash) {
        Write-Information -MessageData ('Formatted {0}' -f $scriptPath) -InformationAction Continue;
        $formatted = $true;
    }
    else {
        Write-Information -MessageData ('No changes to {0}' -f $scriptPath) -InformationAction Continue;
    }
}

if ($formatted -and $exitCodeOnFormat) {
    exit -1;
}
