function Remove-LazyModule {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [String]$Name
  )
  $PSModulePath = "$HOME\Documents\PowerShell\Modules"
  $JunctionPath = Join-Path $PSModulePath $Name
  $item = Get-Item $JunctionPath -ErrorAction SilentlyContinue

  if (-not $item) {
    Write-Error "No module link found at $JunctionPath"
    return
  } 
  if ($item.LinkType -ne "Junction") {
    Write-Error "Path exists but is not a junction: $JunctionPath"
    return
  } 

  Write-Verbose "Removing Junction at $JunctionPath"
  Remove-Item $JunctionPath -Force
}
