
$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url        = 'https://downloads.remarkable.com/desktop/production/win/reMarkable-3.0.4.675-win32.exe'


  softwareName  = 'reMarkable*'

  checksum      = '77f051d912047a9fc32612eccaf90849efbd7627e688e5b0763b9013482e1a3c'
  checksumType  = 'sha256'

  silentArgs   = '--accept-licenses --default-answer --confirm-command install'
}

Install-ChocolateyPackage @packageArgs

















