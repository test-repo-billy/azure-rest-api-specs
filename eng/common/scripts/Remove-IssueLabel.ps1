[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [Parameter(Mandatory = $true)]
  [string]$RepoOwner,

  [Parameter(Mandatory = $true)]
  [string]$RepoName,

  [Parameter(Mandatory = $true)]
  [string]$IssueNumber,

  [Parameter(Mandatory = $true)]
  [string]$LabelName,

  [Parameter(Mandatory = $true)]
  [string]$AuthToken
)

. (Join-Path $PSScriptRoot common.ps1)

try {
  Remove-GitHubIssueLabel -RepoOwner $RepoOwner -RepoName $RepoName `
  -IssueNumber $IssueNumber -LabelName $LabelName -AuthToken $AuthToken
}
catch {
  LogError "Remove-GithubIssueLabel failed with exception:`n$_"
  exit 1
}