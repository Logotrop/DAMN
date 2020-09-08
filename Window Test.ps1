#requires -version 3
Import-Module .\AutoItX.psd1
while ($True) {
    Start-Sleep -Milliseconds 500
    $winhandle = Get-AU3WinHandle -Title "France"
    Show-AU3WinActivate -WinHandle $winhandle
}