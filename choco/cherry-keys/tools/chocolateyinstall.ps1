$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  url        = 'https://content.cherry.de/fileadmin/media/Corporate/Software/CherryKeys_x86_1_0_7.msi'
  url64bit      = 'https://content.cherry.de/fileadmin/media/Corporate/Software/CherryKeys_x64_1_0_7__1_.msi'

  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'

  softwareName  = 'CHERRY KEYS*'

  checksum      = 'd267ba9839004957c8ef470e9b54e9f98137685effc61072947e31c873b1bf97'
  checksumType  = 'SHA256'
  checksum64    = 'e7b91d2e9a7f7074252d5fb011831b5a6247e6a33bdabb73e68f2ffc198eaed3'
  checksumType64= 'SHA256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
