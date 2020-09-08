function OPSignin {

    $Session_Token = Invoke-Expression "$pwd\Op\op.exe signin ibm --raw"
    Out-File -FilePath $pwd\session.txt -Encoding ASCII -InputObject $Session_Token
    $TimeFile = Get-Date
    $TimeFile = $TimeFile.AddMinutes(30)
    Out-File -Append $pwd\session.txt -Encoding ASCII -InputObject $TimeFile
}
function OPSetup {
    $email = Read-Host -Prompt 'Enter your work email'
    Invoke-Expression "op signin ibm.ent.1password.com $email"
    OPSignin
    Invoke-Expression "export OP_SESSION_ibm=$Session_Token"
    
}

if (!(Test-Path $pwd\Op\op.exe)) {
    Invoke-WebRequest "https://cache.agilebits.com/dist/1P/op/pkg/v1.4.0/op_windows_amd64_v1.4.0.zip" -OutFile OP.zip
    Expand-Archive -Path $pwd\op.zip -DestinationPath $pwd\Op
}
OPSetup