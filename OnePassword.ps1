#requires -version 3
#Signin into OnePassword
function OPSignin {
    $Session_Token = Invoke-Expression "$OPDIR signin ibm --raw" #Get Global Session Token for all Signups up to 30 mins after

    #Make Enviromental variable OPST = One Password Session Token, That will hold Session in PATH
    Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST','$Session_Token',[System.EnvironmentVariableTarget]::User)"
    
    Out-File -FilePath $pwd\session.txt -Encoding ASCII -InputObject $Session_Token #Backup Session?

    
    $TimeFile = Get-Date #Time stamp to verify age of the session
    $TimeFile = $TimeFile.AddMinutes(30)

    #Make Enviromental variable OPTF = One Password Time File, That will hold Time in PATH
    Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPTF','$TimeFile',[System.EnvironmentVariableTarget]::User)"
    
    Out-File -Append $pwd\session.txt -Encoding ASCII -InputObject $TimeFile  #Backup Time?
}



if (!(Test-Path $pwd\Op\op.exe)) {
    Write-Output "OnePassword CLI Tool not found! Trying to istall it for you!"
    #OnePassword CLI tool instalation if not installed
    Invoke-WebRequest "https://cache.agilebits.com/dist/1P/op/pkg/v1.4.0/op_windows_amd64_v1.4.0.zip" -OutFile OP.zip
    Expand-Archive -Path $pwd\op.zip -DestinationPath $pwd\Op

    #Create Enviromental variables needed for this to work
    Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST',' ',[System.EnvironmentVariableTarget]::User)"
    Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPTF',' ',[System.EnvironmentVariableTarget]::User)"
}
[String]$OPDIR = "$pwd\Op\op.exe"




$CurrentTime = Get-date #Guess What this does

#Get values from enviromental variables
$Session_Token = Invoke-Expression "[System.Environment]::GetEnvironmentVariable('OPST',[System.EnvironmentVariableTarget]::User)"
#$TimeFile = Invoke-Expression "[System.Environment]::GetEnvironmentVariable('OPFT',[System.EnvironmentVariableTarget]::User)"

#Check if session exists
if ($Session_Token -eq '' -or $Session_Token -eq ' ' -or $Session_Token -eq '0') {
    
    Write-Output "No Session Token in ENV!"
    if (Test-Path $pwd\session.txt) {
        #if session file exists
        #Try to get Backup Session and Time from file
        $SessionFile = Get-Content -Path $pwd\session.txt -TotalCount 1 
        #$TimeFile = ((Get-Content -Path $pwd\session.txt -TotalCount 3)[-1])
        Write-Output "Session backup file exists!"

        if ($SessionFile -eq '') {
            #If backup Session is empty -> Signin
            Write-Output "No Session in Backup File!"
            OPSignin
        }
        else {
            #If Backup Exists -> Use it as Session token

            #There should be a check for a timestamp if the session is valid

            $Session_Token = $SessionFile #Make Backup Session Main Session variable
            Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST','$Session_Token',[System.EnvironmentVariableTarget]::User)"
            Write-Output "Using Session From Backup File!"
        }
    }
    else {
        Write-Output "No Session.txt backup file!"
        OPSignin #Signin and make a Backup File
        $Session_Token = Invoke-Expression "[System.Environment]::GetEnvironmentVariable('OPST',[System.EnvironmentVariableTarget]::User)"
    }
    
}
else {
    Write-Output "Found Session ENV Variable!"
}
#Write-Output($Session_Token) #Does it work?
#Write-Output((Get-Content -Path $pwd\session.txt -TotalCount 3)[-1]) #Is backup working?



#List all entries in OnePassword
#$allitems = "C://op/op.exe get item - --fields password username title --session $Session_Token"

#List all Logins 
$allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token

#Client List
$clients = '*Klesia*', '*Fnac*', '*GEMB*', '*Swisslife*Test*', '*Swisslife*Prod*', '*Mutualise*', '*Fraikin*', '*Util 1*', '*Util 2*', '*Util 3*', '*Manpower*', '*Trenitalia*', '*Tsod*', '*Carrefour*', '*PSA*', '*SNCF*', '*Notes*', '*TOX*', '*BlueZzz*','*KlesiaFMP*'

#Client Array of usernames and passwords
$Credentials = @()
for ($i = 0; $i -lt $clients.Count; $i++) {
    $Credentials += @(
        [pscustomobject]@{Title='';username='';password=''}
    )    
}
<#
#Clients
$Klesia = 
$Fnac =
$GEMB =
$Mutualized =
$Fraikin =
$Utils =
$Manpower =
$Trenitalia =
$Tsod =
$Carefour =
$PSA =
$SNCF =

#Applications
$Notes =
$TOX =
$BlueZzz =

#>
$ArrayOfLogins = Invoke-Expression $allLogins #Get all logins from OnePassword

while ( $Null -eq $ArrayOfLogins) {
    OPSignin
    $Session_Token = Invoke-Expression "[System.Environment]::GetEnvironmentVariable('OPST',[System.EnvironmentVariableTarget]::User)"
    $allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token
    $ArrayOfLogins = Invoke-Expression $allLogins
}
#Go thru all logins one by one
foreach ($i in $ArrayOfLogins) {
    $i = $i.replace('"', "")
    $i = $i.Replace("{", "")
    $i = $i.replace('}', "")
    foreach ($client in $clients) {
        if ($i -like $client ) {
            $i = $i.Replace('"',"")
            $toarray = $i.split(",")
            $toarray[0] = $toarray[0].replace('password:','')
            $toarray[1] = $toarray[1].replace('title:','')
            $toarray[2] = $toarray[2].replace('username:','')

            $index = $clients.IndexOf($client)-1
            $Credentials[$index] = @(
                [pscustomobject]@{Title=$toarray[1];username=$toarray[2];password=$toarray[0]}
            )  
        }
    }
        
        
}
Write-Output $Credentials
