$manifest = "$PSScriptRoot\PSHttpRouter.psd1"
$versionJson = "$PSScriptRoot"

# Update FileList in manifest
$FileList = @(
    'README.md'
    'PSHttpRouter.psm1'
    'PSHttpRouter.psd1'
    'LICENSE'
)
$FileList += Get-ChildItem "$PSScriptRoot\objs" | Resolve-Path -Relative
$FileList += Get-ChildItem "$PSScriptRoot\en-US" | Resolve-Path -Relative
$FileList += Get-ChildItem "$PSScriptRoot\cmds" | Resolve-Path -Relative
Update-ModuleManifest -Path "$manifest" -FileList $FileList

# Import Module for use
Import-Module -Name PSSemanticVersion -Force

# Update Version in Manifest
$Version = New-SemanticVersion
$Version.FromVersionJson($versionJson) | Out-Null
$Version.Patch++
$Version.ToVersionJson($versionJson) | Out-Null
Update-ModuleManifest -Path $manifest -ModuleVersion $Version.ToSystemVersion()

Publish-Module -Path $PSScriptRoot -NuGetApiKey $APIKey