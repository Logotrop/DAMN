Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName System.Drawing
#Version Control
$repo = "Logotrop/DAMN"
$file = "DAMN.zip"
try {
    $CurrentVersion = Get-Content -Path $pwd\version.txt -TotalCount 1
}
Catch {
    $CurrentVersion = "1.0"
}

$releases = "https://api.github.com/repos/$repo/releases"
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name
Write-Host ("Running Version " + $CurrentVersion)
Write-Host ("Latest Version " + $tag)
if ($CurrentVersion -ne $tag) {
    $download = "https://github.com/$repo/releases/download/$tag/$file"
    $name = $file.Split(".")[0]
    $zip = "$name-$tag.zip"
    $dir = "$name-$tag"
    
    Write-Host Dowloading latest release
    Invoke-WebRequest $download -Out $zip
    
    Write-Host Extracting release files
    Expand-Archive $zip -Force
    #Remove Temp Zip
    Remove-Item $zip -Force
    # Moving from temp dir to This dir
    $files = Get-ChildItem -Path $dir -Recurse
    ForEach ($file In $files) {
        
        try {
            Copy-Item -Path $file.FullName -Destination $file.FullName.Replace("\$dir", "") -Force
        }
        catch {
            Write-Host "Exception! $file"
            If ($file -Match "DAMN.exe") {
                [System.Windows.Forms.MessageBox]::Show( "Error-02 Error downloading version - $tag`nPlease report it on Github`nhttps://github.com/Logotrop/DAMN/issues" , "Error-02")
            }
            
        }
        
    }    
    # Removing temp folder
    Remove-Item $dir -Recurse -Force
    [System.Windows.Forms.MessageBox]::Show( "DAMN succesfuly updated!" , "Update OK")
}
else {
    [System.Windows.Forms.MessageBox]::Show( "You are running the latest version!" , "Update OK")
}