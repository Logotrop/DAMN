#requires -version 3

$Session_Token = Invoke-Expression "C://op/op.exe signin ibm --raw"
$allitems = "C://op/op.exe get item - --fields password username title"
$allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token

#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arrays?view=powershell-7


#Write-Output($Session_Token)
$ArrayOfLogins = Invoke-Expression $allLogins
#Write-Output($ArrayOfLogins)
#Write-Output($ArrayOfLogins.GetType())
foreach ($i in $ArrayOfLogins) {
    #Write-Output($i.GetType())
    
    $i = $i.replace('"',"")
    $i = $i.Replace("{","")
    $i = $i.replace('}',"")
    $toarray = $i.split(",")
    
    foreach ($a in $toarray.Replace('"',"")) {
        Write-Output($a)
    }
}