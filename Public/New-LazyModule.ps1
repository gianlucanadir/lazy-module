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

  # Path has not been passed, so I create the folder structure at the current path
  if (-not $Path) {
    $CurrentLocation = Get-Location | Select-Object -ExpandProperty Path
    $FolderPath = Join-Path $CurrentLocation $Name
    $FullPath = Join-Path $FolderPath $Psd1

    # There is a folder with the same name, write error and exit
    if ((Test-Path $FullPath) -and -not $Force ) {
      Write-Error "Module folder already exists at $FullPath. Use -Force to continue."
      return
    } 

    # Proceed with the creation
    Write-Verbose "Creating $Psd1 at $FolderPath"
    New-Item -Type File -Path $FullPath -Force
    $Path = $FullPath
  } 
  # Path has been passed, create the folder there
  else {
    $FolderPath = Join-Path $Path $Name
    $FullPath = Join-Path $FolderPath $Psd1
    if ((Test-Path $FullPath) -and -not $Force ) {
      Write-Error "Module folder already exists at $FullPath. Use -Force to continue."
      return
    } 
    Write-Verbose "Creating $Psd1 at $FolderPath"
    New-Item -Type File -Path $FullPath -Force
    $Path = $FullPath
  }

  # If no Author has been passed, use Git user.name otherwise use $Env:USERNAME
  if (-not $Author) {
    if (Get-Command git -ErrorAction SilentlyContinue) {
      Write-Verbose "Adding Author $Author from Git"
      $Author = git config user.name
    } else {
      Write-Verbose "Adding Author $Author from `$Env:USERNAME"
      $Author = $Env:USERNAME
    }
  }

  # Create Junction to have a linked folder at the $PSModulePath
  if (-not $NoJunction) {
    $PSModulePath = "$HOME\Documents\PowerShell\Modules"
    $FullPath = Join-Path $PSModulePath $Name
    $CurrentLocation = Get-Location | Select-Object -ExpandProperty Path
    $FolderPath = Join-Path $CurrentLocation $Name
    if ((Test-Path $FullPath) -and -not $Force ) {
      Write-Error "Module folder already exists at $FullPath. Use -Force to continue."
      return
    } 
    Write-Verbose "Creating Junction at $FullPath"
    New-Item -ItemType Junction -Path $FullPath -Target $FolderPath -Force
  }

  New-ModuleManifest -path $Path -RootModule $Psm1 -Author $Author -Description $Description
}