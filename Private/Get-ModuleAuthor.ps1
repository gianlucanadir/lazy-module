Function Set-ModuleAuthor {
  param(
    [String]$Author
  )
  # If no Author has been passed, use Git user.name otherwise use $Env:USERNAME
  if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Verbose "Adding Author $Author from Git"
    $Author = git config user.name
  } else {
    Write-Verbose "Adding Author $Author from `$Env:USERNAME"
    $Author = $Env:USERNAME
  }
  $Author
}