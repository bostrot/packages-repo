import-module au

$releases = 'https://www.cherry.de/service/software/keys'

function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
     $regex   = '.msi$'
     $url     = $download_page.links | ? href -match $regex | select -First 1 -expand href
     $url64     = $download_page.links | ? href -match $regex | select -Last 1 -expand href
     $version = $url -split '_|.msi' | select -Last 3 -Skip 1
     $version = $version -join "." # e.g. 1.0.7
     return @{ Version = $version; URL32 = $url; URL64 = $url64 }
}

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

update