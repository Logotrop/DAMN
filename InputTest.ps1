#requires -version 3
Import-Module .\AutoItX.psd1
#Get-Command *AU3*

function IsOpen {
    Start-Sleep -Milliseconds 500
    $winhandle = Get-AU3WinHandle -Title $ProcessName
    Show-AU3WinActivate -WinHandle $winhandle
}


$NeedsEnter = $False
$application = $args[0]
switch ($application) {
    TOX {
        $ProcessName = "France" 
        $username = $args[1];
        $password = $args[2];
        $arguments = "https://sniaccess.mop.esni.ibm.com:900 France " + $username
        $username = ""
        $filepath = "C:\Program Files (x86)\Toxclient\toxclient.exe"
        $NeedsEnter = $True
        Break
    }
    
    Notes {
        $ProcessName = "IBM Notes"
        $password = $args[1];
        $arguments = ""
        $filepath = "C:\Notes\notes.exe"
        $NeedsEnter = $True
        Break
    }
    
    BlueZzz {
        $ProcessName = "BlueZzz login"
        $password = $args[1];
        $arguments = ""
        $filepath = "C:\Users\MarekDobes\Desktop\BlueZzz\"
        $NeedsEnter = $True
        Break
    }
    
}
<#
$username=$args[1]
$password=$args[2]
#>
#https://stackoverflow.com/questions/24286055/user-input-for-external-program-in-powershell
$Wscript = New-Object -com wscript.shell
if ($application -eq "BlueZzz") {
    Invoke-Expression "cmd.exe start /B $filepath\runtime\jre\bin\javaw.exe -jar $filepath\app\bluezzz-login.jar"

}
else {
    if ($arguments -ne "") {
        Start-Process -FilePath $filepath -Argumentlist $arguments;
    }
    else {
        Start-Process -FilePath $filepath
    }
}
    for ($i = 0; $i -lt 500; $i++) {
        Start-Sleep -Milliseconds 500
        $winhandle = Get-AU3WinHandle -Title $ProcessName
        $isone = Show-AU3WinActivate -WinHandle $winhandle
        if ($isone -eq 1) {
            if ($username -ne "") {
                $wscript.SendKeys($username);   
            }
        
            if ($password -ne "") {
                $wscript.SendKeys($password);   
            }
            if ($NeedsEnter) {
                $wscript.SendKeys("{Enter}")   
            }
            Break
        } 

    }
     
    


