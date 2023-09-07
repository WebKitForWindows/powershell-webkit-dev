param(
    [switch]$exitCodeOnError = $false,
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

Import-ModuleLocally -Name PSScriptAnalyzer -Version 1.21.0;

# Use Invoke-Formatter on all code
# Using -Exclude breaks the -Filter functionality so a regex using Where-Object is used instead
$psScripts = Get-ChildItem -Path $PSScriptRoot -Exclude 'psmodules' | `
     Get-ChildItem -Recurse | `
     Where-Object { $_.FullName -match '.*\.ps1$' }
$issues = 0;
$files = 0;

foreach ($script in $psScripts) {
    $files++;
    $scriptPath = $script.FullName;

    Write-Information -MessageData ('Analyzing {0}' -f $scriptPath) -InformationAction Continue;

    $records = Invoke-ScriptAnalyzer -Path $scriptPath -Settings (Join-Path $PSScriptRoot 'ScriptAnalyzerSettings.txt');
    if ($records) {
        foreach ($record in $records) {
            $issues++;
            Write-Information -MessageData ('{0}:{1}: {2} {3}' -f $record.ScriptName,$record.Line,$record.RuleName,$record.Message) -InformationAction Continue;
        }
    }
}

Write-Information -MessageData ('Found {0} issues across {1} files' -f $issues,$files) -InformationAction Continue;

if ($issues -gt 0 -and $exitCodeOnError) {
    exit -1;
}
