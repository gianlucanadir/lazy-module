function New-LazyModule {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [String]$Name,
    [String]$Path,
    [String]$Author,
    [String]$Description,
    [Switch]$NoJunction,
    [Switch]$Force
  )
  $Psm1 = "$Name.psm1"
  $Psd1Path = New-ModuleStructure -Path $Path -Name $Name -Force $Force

  if (-not $Author) {
    $Author = Get-ModuleAuthor -Author $Author
  }

  if (-not $NoJunction) {
    New-ModuleJunction -Name $Name -Path $Path -Force $Force
  }

  New-ModuleManifest -path $Psd1Path -RootModule $Psm1 -Author $Author -Description $Description
}