#requires -version 1
<#
add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms
Calc
start-sleep -Milliseconds 500

Invoke-Expression [Microsoft.VisualBasic.Interaction]::AppActivate("Calc")
Invoke-Expression [System.Windows.Forms.SendKeys]::SendWait("1{ADD}1=")
#>


#https://stackoverflow.com/questions/24286055/user-input-for-external-program-in-powershell
$Wscript = New-Object -com wscript.shell
Start-Process -FilePath "C:\Program Files (x86)\Toxclient\toxclient.exe" -Argumentlist "https://sniaccess.mop.esni.ibm.com:900 France CZZZ03BC";Start-sleep -seconds 1;$wscript.SendKeys("15charactersistoolong!");$wscript.SendKeys("{Enter}")