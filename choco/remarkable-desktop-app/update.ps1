import-module au

$releases = 'https://downloads.remarkable.com/latest/windows'

function global:au_GetLatest {
     # Get release link from redirect header and ignore errors
     $page = Invoke-WebRequest -Uri $releases -MaximumRedirection 0 -UseBasicParsing -ErrorAction SilentlyContinue -SkipHttpErrorCheck
     $url = $page.Headers['Location']
     # Get version from link (e.g. reMarkable-3.0.4.675-win32.exe)
     $version = $url -split '-|.exe' | select -Last 1 -Skip 2
     return @{ Version = $version; URL32 = $url }
}

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyinstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
    }
}

update