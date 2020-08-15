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

function OPSignin {

    $Session_Token = Invoke-Expression "$OPDIR signin ibm --raw"
    Out-File -FilePath $pwd\session.txt -Encoding ASCII -InputObject $Session_Token
    $TimeFile = Get-Date
    $TimeFile = $TimeFile.AddMinutes(30)
    Out-File -Append $pwd\session.txt -Encoding ASCII -InputObject $TimeFile
}

if (!(Test-Path $pwd\Op\op.exe)) {
    Invoke-WebRequest "https://cache.agilebits.com/dist/1P/op/pkg/v1.4.0/op_windows_amd64_v1.4.0.zip" -OutFile OP.zip
    Expand-Archive -Path $pwd\op.zip -DestinationPath $pwd\Op
}
[String]$OPDIR = "$pwd\Op\op.exe"


#Signin into OnePassword

#Check if session exists
$CurrentTime = Get-date
if (Test-Path $pwd\session.txt) {
    $SessionFile = Get-Content -Path $pwd\session.txt -TotalCount 1
    $TimeFile = ((Get-Content -Path $pwd\session.txt -TotalCount 3)[-1])
    
    if ($SessionFile -eq '') {
        OPSignin
    } else {
        $Session_Token = $SessionFile
    }
    
    if ([String]$TimeFile -eq '') {
        OPSignin
    } else {
        $TimeBefore = $TimeFile
    }

    if ($TimeBefore -gt $CurrentTime ) {

        $Session_Token = $SessionFile
        Write-Output("Hello!")
    } else {
        OPSignin
    }
    
} else {
    OPSignin
    $Session_Token = Get-Content -Path $pwd\session.txt -TotalCount 1
} 
#Write-Output($Session_Token)
Write-Output((Get-Content -Path $pwd\session.txt -TotalCount 3)[-1])

$allitems = "C://op/op.exe get item - --fields password username title"
$allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token

$clients = '*Klesia*','*Fnac*','*GEMB*','*MMB*','*Swisslife*','*Mutualized*','*Fraikin*','*Util*','*Manpower*','*Trenitalia*','*Tsod*','*Carefour*','*PSA*','*SNCF*','*IBM*'




#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arrays?view=powershell-7

#Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST','$Session_Token',[System.EnvironmentVariableTarget]::User)"


#Write-Output($Session_Token)

$ArrayOfLogins = Invoke-Expression $allLogins

#Write-Output($ArrayOfLogins)
#Write-Output($ArrayOfLogins.GetType())
#if (false) {

    foreach ($i in $ArrayOfLogins) {
        #Write-Output($i.GetType())
        foreach ($client in $clients) {
            #Write-Output($i)
            $i = $i.replace('"',"")
            $i = $i.Replace("{","")
            $i = $i.replace('}',"")
            if ($i -like $client ) {
                Write-Output($client)
                $toarray = $i.split(",")
                foreach ($a in $toarray.Replace('"',"")) {
                    Write-Output($a)
                }
                Write-Output('')    
            }
        }
        
        
    }
#}
