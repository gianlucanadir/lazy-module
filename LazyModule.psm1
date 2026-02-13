function New-PSModule {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [String]$Name,
    [String]$Path,
    [String]$Author,
    [String]$Description,
    [Switch]$Junction
  )

  $Psd1 = "$Name.psd1"
  $Psm1 = "$Name.psm1"


  if (-not $Path) {
    $CurrentLocation = Get-Location | Select-Object -ExpandProperty Path
    $FolderPath = Join-Path $CurrentLocation $Name
    $FullPath = Join-Path $FolderPath $Psd1
    New-Item -Type File -Force -Path $FullPath
    $Path = $FullPath
  } else {
    $FolderPath = Join-Path $Path $Name
    $FullPath = Join-Path $FolderPath $Psd1
    New-Item -Type File -Force -Path $FullPath
    $Path = $FullPath
  }

  if (-not $Author) {
    $Author = $Env:USERNAME
  }

  if ($Junction) {
    $PSModulePath = "$HOME\Documents\PowerShell\Module"
    $FullPath = Join-Path $PSModulePath $Name
    $CurrentLocation = Get-Location | Select-Object -ExpandProperty Path
    $FolderPath = Join-Path $CurrentLocation $Name
    New-Item -ItemType Junction -Path $FullPath -Target $FolderPath
  }

  New-ModuleManifest -path $Path -RootModule $Psm1 -Author $Author -Description $Description
}