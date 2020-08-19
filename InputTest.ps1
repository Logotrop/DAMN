#requires -version 1

$application=$args[0]
switch ($application) {
    TOX { 
        $username=$args[1];
        $password=$args[2];
        $arguments = "https://sniaccess.mop.esni.ibm.com:900 France " + $username
        $filepath = "C:\Program Files (x86)\Toxclient\toxclient.exe"
        Break
     }
    
    Notes { 
        $password=$args[1];
        $arguments = ""
        $filepath = "C:\Notes\notes.exe"
        Break
     }
    
}


<#
$username=$args[1]
$password=$args[2]
#>



#https://stackoverflow.com/questions/24286055/user-input-for-external-program-in-powershell
$Wscript = New-Object -com wscript.shell
if ($arguments -ne "") {
    Start-Process -FilePath $filepath -Argumentlist $arguments;    
} else {
    Start-Process -FilePath $filepath
}
  
Start-sleep -seconds 20;
if ($username -ne "") {
    $wscript.SendKeys($username);   
}
$wscript.SendKeys($password);
$wscript.SendKeys("{Enter}")