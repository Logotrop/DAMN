#requires -version 3
Import-Module .\AutoItX.psd1
while ($True) {
    Start-Sleep -Milliseconds 500
    $winhandle = Get-AU3WinHandle -Title "IBM Notes"
    Show-AU3WinActivate -WinHandle $winhandle
}