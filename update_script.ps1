# Check if there are any changes in the choco folder
$folders = Get-ChildItem -Path ./choco -Directory
for ($i = 0; $i -lt $folders.Length; $i++) {
    $folder = $folders[$i].Name
    $update_path = "./choco/$folder/update.ps1"

    # Check if update.ps1 exists
    if (Test-Path $update_path) {
        Write-Host "Running update script for $folder..."
        $git_status = $(git status -s)
        $matches = $(git status -s |
            Select-String -Pattern "choco/$folder" |
            ForEach-Object { $_.Matches.Value })

        # Check if file is modified
        if ($matches.Length -gt 0) {
            # Get version from nuspec file between <version> and </version>
            $version = $(Get-Content "./choco/$folder/$folder.nuspec" |
                Select-String -Pattern "<version>.*</version>" |
                ForEach-Object { $_.Matches.Value } |
                ForEach-Object { $_.Split(">")[1] } |
                ForEach-Object { $_.Split("<")[0] })
            
            # Commit update
            Write-Host "Committing $folder v$version..."
            git add ./choco/$folder
            git commit -m "Updated $folder v$version"

            # Try packing or skip if it fails
            Write-Host "Packing $folder v$version..."
            choco pack $folder -y || continue
            Write-Host "Pushing $folder v$version..."
            choco push $folder/*.nupkg --source https://push.chocolatey.org/ --api-key ${{ secrets.CHOCO_API_KEY }}; 
        }
    }
}
