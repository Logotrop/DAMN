#requires -version 3
<#
try {
    Invoke-Expression Get-ChildItem Env:OPT
}
catch {
    Write-Output "Time Variable not Setup!"
    Write-Output "Running Initial Setup!"
    [System.Environment]::SetEnvironmentVariable('OPT','0',[System.EnvironmentVariableTarget]::User)
    Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST','0',[System.EnvironmentVariableTarget]::User)"
}
finally {
    $Time = Get-ChildItem Env:OPT
}
$CurrentTime = Invoke-Expression "Get-Date -UFormat '%A %B/%d/%Y %T %Z'"
$CurrentTime = Get-Date
$CurrentTime.ToUniversalTime()
$Time = Get-ChildItem Env:OPT
if (!$Time) {
    $Time = $CurrentTime
}
if ($Time = 30) {
    $Session_Token = Invoke-Expression "C://op/op.exe signin ibm --raw"
}
#>
$Session_Token = Invoke-Expression "C://op/op.exe signin ibm --raw"
$allitems = "C://op/op.exe get item - --fields password username title"
$allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token

#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arrays?view=powershell-7

Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST','$Session_Token',[System.EnvironmentVariableTarget]::User)"
#Write-Output($Session_Token)
$ArrayOfLogins = Invoke-Expression $allLogins
#Write-Output($ArrayOfLogins)
#Write-Output($ArrayOfLogins.GetType())
#if (false) {
    foreach ($i in $ArrayOfLogins) {
        #Write-Output($i.GetType())
        
        $i = $i.replace('"',"")
        $i = $i.Replace("{","")
        $i = $i.replace('}',"")
        $toarray = $i.split(",")
        Write-Output('')
        foreach ($a in $toarray.Replace('"',"")) {
            Write-Output($a)
        }
    }
#}
