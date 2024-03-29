#
# Module manifest for module 'WebKitDev'
#
# Generated by: Don Olmstead
#
# Generated on: 3/20/2017
#

@{

    # Script module or binary module file associated with this manifest.
    # RootModule = ''

    # Version number of this module.
    ModuleVersion     = '0.5.2'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '479d43a3-bb96-460a-9330-d5cdb8b28ec6'

    # Author of this module
    Author            = 'Don Olmstead'

    # Company or vendor of this module
    CompanyName       = 'Unknown'

    # Copyright statement for this module
    Copyright         = '(c) 2017 Don Olmstead. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'PowerShell scripts for WebKit development on Windows'

    # Minimum version of the Windows PowerShell engine required by this module
    # PowerShellVersion = ''

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(
        @{ModuleName = '7Zip4Powershell'; ModuleVersion = '1.13.0'; MaximumVersion = '1.999.999'; },
        @{ModuleName = 'VSSetup'; ModuleVersion = '2.2.16'; MaximumVersion = '2.999.999'; }
    )
    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules     = @(
        'Functions/Expand-SourceArchive.ps1',
        'Functions/Get-Font.ps1',
        'Functions/Get-SourceCodeRelease.ps1',
        'Functions/Get-VSBuildTools2015InstallationPath.ps1',
        'Functions/Get-VSBuildTools2015VCVarsAllPath.ps1',
        'Functions/Get-VSBuildTools2017InstallationPath.ps1',
        'Functions/Get-VSBuildTools2017VCVarsAllPath.ps1',
        'Functions/Get-VSBuildTools2019InstallationPath.ps1',
        'Functions/Get-VSBuildTools2019VCVarsAllPath.ps1',
        'Functions/Get-VSBuildTools2022InstallationPath.ps1',
        'Functions/Get-VSBuildTools2022VCVarsAllPath.ps1',
        'Functions/Get-WebKitGitHubUrl.ps1',
        'Functions/Get-WebKitGitUrl.ps1',
        'Functions/Get-WebKitSVNSnapshotUrl.ps1',
        'Functions/Get-WebKitSVNUrl.ps1',
        'Functions/Initialize-NinjaEnvironment.ps1',
        'Functions/Initialize-VSEnvironment.ps1',
        'Functions/Install-AhemFont.ps1',
        'Functions/Install-Bison.ps1',
        'Functions/Install-CMake.ps1',
        'Functions/Install-DiffUtils.ps1',
        'Functions/Install-Flex.ps1',
        'Functions/Install-Font.ps1',
        'Functions/Install-FromArchive.ps1',
        'Functions/Install-FromExe.ps1',
        'Functions/Install-FromExeDownload.ps1',
        'Functions/Install-FromMsi.ps1',
        'Functions/Install-FromPacman.ps1',
        'Functions/Install-Git.ps1',
        'Functions/Install-Gperf.ps1',
        'Functions/Install-LLVM.ps1',
        'Functions/Install-Make.ps1',
        'Functions/Install-MinioClient.ps1',
        'Functions/Install-MSYS2.ps1',
        'Functions/Install-Nasm.ps1',
        'Functions/Install-Ninja.ps1',
        'Functions/Install-NuGet.ps1',
        'Functions/Install-Patch.ps1',
        'Functions/Install-Perl.ps1',
        'Functions/Install-Python.ps1',
        'Functions/Install-Ruby.ps1',
        'Functions/Install-SVN.ps1',
        'Functions/Install-Xampp.ps1',
        'Functions/Install-VSBuildTools2015.ps1',
        'Functions/Install-VSBuildTools2017.ps1',
        'Functions/Install-VSBuildTools2019.ps1',
        'Functions/Install-VSBuildTools2022.ps1',
        'Functions/Install-Windows10SDK.ps1',
        'Functions/Invoke-CMakeBuild.ps1',
        'Functions/Invoke-WebFileRequest.ps1',
        'Functions/Register-SystemPath.ps1',
        'Functions/Remove-TempFiles.ps1',
        'Functions/Select-VSEnvironment.ps1',
        'Functions/Update-ScriptPath.ps1',
        'Functions/Update-XamppPerlLocation.ps1',
        'Functions/Update-XamppPythonLocation.ps1'
    )

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Expand-SourceArchive',
        'Get-Font',
        'Get-SourceCodeRelease',
        'Get-VSBuildTools2015InstallationPath',
        'Get-VSBuildTools2015VCVarsAllPath',
        'Get-VSBuildTools2017InstallationPath',
        'Get-VSBuildTools2017VCVarsAllPath',
        'Get-VSBuildTools2019InstallationPath',
        'Get-VSBuildTools2019VCVarsAllPath',
        'Get-VSBuildTools2022InstallationPath',
        'Get-VSBuildTools2022VCVarsAllPath',
        'Get-WebKitGitHubUrl',
        'Get-WebKitGitUrl',
        'Get-WebKitSVNSnapshotUrl',
        'Get-WebKitSVNUrl',
        'Initialize-NinjaEnvironment',
        'Initialize-VSEnvironment',
        'Install-AhemFont',
        'Install-Bison',
        'Install-CMake',
        'Install-DiffUtils',
        'Install-Flex',
        'Install-Font',
        'Install-FromArchive',
        'Install-FromExe',
        'Install-FromExeDownload',
        'Install-FromMsi',
        'Install-FromPacman',
        'Install-Git',
        'Install-Gperf',
        'Install-LLVM',
        'Install-Make',
        'Install-MinioClient',
        'Install-MSYS2',
        'Install-Nasm',
        'Install-Ninja',
        'Install-NuGet',
        'Install-Patch',
        'Install-Perl',
        'Install-Python',
        'Install-Ruby',
        'Install-SVN',
        'Install-VSBuildTools2015',
        'Install-VSBuildTools2017',
        'Install-VSBuildTools2019',
        'Install-VSBuildTools2022',
        'Install-Windows10SDK',
        'Install-Xampp',
        'Invoke-CMakeBuild',
        'Invoke-WebFileRequest',
        'Register-SystemPath',
        'Remove-TempFiles',
        'Select-VSEnvironment',
        'Update-ScriptPath',
        'Update-XamppPerlLocation',
        'Update-XamppPythonLocation'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}
