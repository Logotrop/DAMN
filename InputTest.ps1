#requires -version 3
Import-Module .\AutoItX.psd1
#Get-Command *AU3*

function IsOpen {
    Start-Sleep -Milliseconds 500
    $winhandle = Get-AU3WinHandle -Title $ProcessName
    if ((Show-AU3WinActivate -WinHandle $winhandle) -eq 1) {
        return $True
    } else {
        return $False
    }
}


$NeedsEnter = $False
$application = $args[0]
$username = $args[1];
$password = $args[2];
switch ($application) {
    TOX {
        $ProcessName = "France"
        $arguments = "https://sniaccess.mop.esni.ibm.com:900 France " + $username + " 129.39.143.218 23"
        $username = ""
        $filepath = "C:\Program Files (x86)\Toxclient\toxclient.exe"
        $NeedsEnter = $True
        Break
    }
    
    Notes {
        $ProcessName = "IBM Notes"
        $arguments = ""
        $filepath = "C:\Notes\notes.exe"
        $NeedsEnter = $True
        Break
    }
    
    BlueZzz {
        $ProcessName = "BlueZzz login"
        $AlreadyOpen = "BlueZzz"
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
     
    


