#requires -version 3
#[CmdletBinding()]
$Session_Token = Invoke-Expression "C://op/op.exe signin ibm --raw"
$allitems = "C://op/op.exe get item - --fields password username title"
$allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token
#Invoke-Expression $allitems
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arrays?view=powershell-7
#Invoke-Expression "DEADonepasswordnet1029"
Write-Output($Session_Token)
$Array = Invoke-Expression $allLogins
Write-Output($Array)
Write-Output($Array.GetType())