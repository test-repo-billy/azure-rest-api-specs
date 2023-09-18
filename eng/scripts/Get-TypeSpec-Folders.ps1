[CmdletBinding()]
param (
  [switch]$CheckAll = $false
)
Set-StrictMode -Version 3

. $PSScriptRoot/ChangedFiles-Functions.ps1

$repoPath = Resolve-Path "$PSScriptRoot/../.."
$checkAllPath = "specification"

if ($CheckAll) {
  $changedFiles = $checkAllPath
}
else {
  $changedFiles = @(Get-ChangedFiles -diffFilter "")
  $engOrRootChangedFiles = Get-ChangedEngOrRootFiles $changedFiles

  if ($Env:BUILD_REPOSITORY_NAME -eq 'azure/azure-rest-api-specs' -and $engOrRootChangedFiles) {
    Write-Verbose "Found changes to core eng or root files so checking all specs."
    $changedFiles = $checkAllPath
  }
  else {
    $changedFiles = Get-ChangedFilesUnderSpecification $changedFiles
  }
}
$changedFiles = $changedFiles -replace '\\', '/'

$typespecFolders = @()
foreach ($file in $changedFiles) {
  if ($file -match 'specification(\/[^\/]*\/)*') {
    $path = "$repoPath/$($matches[0])"
    Write-Verbose "Checking for tspconfig files under $path"
    $typespecFolder = Get-ChildItem -path $path tspconfig.* -Recurse
    if ($typespecFolder) {
      $typespecFolders += $typespecFolder.Directory.FullName
    }
  }
}
$typespecFolders = $typespecFolders | ForEach-Object { [IO.Path]::GetRelativePath($repoPath, $_) -replace '\\', '/' } | Sort-Object -Unique

return $typespecFolders
