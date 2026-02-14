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

  $Psd1 = "$Name.psd1"
  $Psm1 = "$Name.psm1"

  # Path has not been passed, so I create the folder structure in the current path
  if (-not $Path) {
    $CurrentLocation = Get-Location | Select-Object -ExpandProperty Path
    $FolderPath = Join-Path $CurrentLocation $Name
    $FullPath = Join-Path $FolderPath $Psd1

    # There is a folder with the same name, throw error
    if ((Test-Path $FullPath) -and -not $Force ) {
      throw "Module folder already exists in $FullPath. Use -Force to continue."
    } 

    # Proceed with the creation
    New-Item -Type File -Path $FullPath -Force
    Write-Verbose "Created $Psd1 in $FolderPath"
    $Path = $FullPath
  } 
  # Path has been passed, create the folder there
  else {
    $FolderPath = Join-Path $Path $Name
    $FullPath = Join-Path $FolderPath $Psd1
    if ((Test-Path $FullPath) -and -not $Force ) {
      throw "Module folder already exists in $FullPath. Use -Force to continue."
    } 
    New-Item -Type File -Path $FullPath -Force
    Write-Verbose "Created $Psd1 in $FolderPath"
    $Path = $FullPath
  }

  # If no Author has been passed, use Git user.name or $Env:USERNAME
  if (-not $Author) {
    if (Get-Command git -ErrorAction SilentlyContinue) {
      $Author = git config user.name
      Write-Verbose "Added Author $Author from Git"
    } else {
      $Author = $Env:USERNAME
      Write-Verbose "Added Author $Author from `$Env:USERNAME"
    }
  }

  # Create Junction to have a linked folder in the $PSModulePath
  if (-not $NoJunction) {
    $PSModulePath = "$HOME\Documents\PowerShell\Modules"
    $FullPath = Join-Path $PSModulePath $Name
    $CurrentLocation = Get-Location | Select-Object -ExpandProperty Path
    $FolderPath = Join-Path $CurrentLocation $Name
    if ((Test-Path $FullPath) -and -not $Force ) {
      throw "Module folder already exists in $FullPath. Use -Force to continue."
    } 
    New-Item -ItemType Junction -Path $FullPath -Target $FolderPath -Force
    Write-Verbose "Added Author $Author from `$Env:USERNAME"
  }

  New-ModuleManifest -path $Path -RootModule $Psm1 -Author $Author -Description $Description
}