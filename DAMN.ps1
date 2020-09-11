#requires -version 3
Import-Module .\AX\AutoItX.psd1 #Import Automation Library
$MasterPassword = ""
Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName System.Drawing
#Signin into OnePassword
function OPSignin {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'DAMN'
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = 'CenterScreen'

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75, 120)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150, 120)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = 'Please enter your Master password:'
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.MaskedTextBox
    $textBox.PasswordChar = "*"
    $textBox.Location = New-Object System.Drawing.Point(10, 40)
    $textBox.Size = New-Object System.Drawing.Size(260, 20)
    $form.Controls.Add($textBox)

    $form.Topmost = $true

    $form.Add_Shown( { $textBox.Select() })
    $resultofform = $form.ShowDialog()

    if ($resultofform -ne [System.Windows.Forms.DialogResult]::Cancel) {
        $MasterPassword = $textBox.Text
        #Get Global Session Token for all Signups up to 30 mins after
        $Session_Token = Invoke-Expression "echo $MasterPassword | $OPDIR signin ibm --raw"
        #Make Enviromental variable OPST = One Password Session Token, That will hold Session in PATH
        Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST','$Session_Token',[System.EnvironmentVariableTarget]::User)"
        Out-File -FilePath $pwd\session.txt -Encoding ASCII -InputObject $Session_Token #Backup Session?
        $TimeFile = Get-Date #Time stamp to verify age of the session
        $TimeFile = $TimeFile.AddMinutes(30)
        #Make Enviromental variable OPTF = One Password Time File, That will hold Time in PATH
        Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPTF','$TimeFile',[System.EnvironmentVariableTarget]::User)"
        Out-File -Append $pwd\session.txt -Encoding ASCII -InputObject $TimeFile  #Backup Time?
    }
    elseif ($resultofform -eq [System.Windows.Forms.DialogResult]::Cancel) {
        exit
    }
}

# Function to find wether a specific login windo
function IsOpen {
    Start-Sleep -Milliseconds 500
    $winhandle = Get-AU3WinHandle -Title $ProcessName
    if ((Show-AU3WinActivate -WinHandle $winhandle) -eq 1) {
        return $True
    }
    else {
        return $False
    }
}

function WindowManager {
    
    $NeedsEnter = $False
    if ($null -ne $args[0]) {
        $application = $args[0]
        $username = $args[1];
        $password = $args[2];
    }
    else {
        $application = "Error"
    }

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
            $ProcessName = "BlueZzz Login"
            $AlreadyOpen = "BlueZzz"
            $arguments = ""
            $filepath = "C:\Users\MarekDobes\Desktop\BlueZzz\"
            $NeedsEnter = $True
            Break
        }

        Error {
            Invoke-Expression "[System.Windows.MessageBox]::Show('Invalid Option - Error code: 01','Error - 01','OK','Error')"
            exit
        }
    
    }
    <#
$username=$args[1]
$password=$args[2]
#>
    #https://stackoverflow.com/questions/24286055/user-input-for-external-program-in-powershell
    $Wscript = New-Object -com wscript.shell
    if ($application -eq "BlueZzz") {
        Invoke-Expression "cd Bluezzz"
        $bluezzpath = ".\BlueZzzStart.cmd"
        Start-Process $bluezzpath
        Invoke-Expression "cd .."

    }
    else {
        if ($arguments -ne "") {
            Start-Process -FilePath $filepath -Argumentlist $arguments;
        }
        else {
            Start-Process -FilePath $filepath
        }
    }

    for ($i = 0; $i -lt 60; $i++) {
        Start-Sleep -Milliseconds 500
        Write-Output "Pass $i "
        Write-Output $username
        Write-Output $password
        Write-Output $ProcessName
        $winhandle = Get-AU3WinHandle -Title $ProcessName
        $isone = Show-AU3WinActivate -WinHandle $winhandle
        if ($isone -eq 1) {
            Write-Output "Its Open"
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
        else {
            Write-Output "Waiting for app to open"
        }

    }
}

if (!(Test-Path $pwd\Op\op.exe)) {
    Write-Output "OnePassword CLI Tool not found! Trying to istall it for you!"
    #OnePassword CLI tool instalation if not installed
    Invoke-WebRequest "https://cache.agilebits.com/dist/1P/op/pkg/v1.6.0/op_windows_amd64_v1.6.0.zip" -OutFile OP.zip
    Expand-Archive -Path $pwd\op.zip -DestinationPath $pwd\Op

    #Create Enviromental variables needed for this to work
    Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST',' ',[System.EnvironmentVariableTarget]::User)"
    Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPTF',' ',[System.EnvironmentVariableTarget]::User)"
}
[String]$OPDIR = "$pwd\Op\op.exe"


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

#List all Logins 
$allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token

#Client List   1           2         3              4                    5               6              7           8
#$clients = '*Klesia*', '*Fnac*', '*GEMB*', '*Swisslife*Test*', '*Swisslife*Prod*', '*Mutualise*', '*Fraikin*', '*Util 1*', '*Util 2*', '*Util 3*', '*Manpower*', '*Trenitalia*', '*Tsod*', '*Carrefour*', '*PSA*', '*SNCF*', '*Notes*', '*TOX*', '*BlueZzz*', '*KlesiaFMP*', 'IBM'

#Client Array of usernames and passwords
$Credentials = @()
<#function Credentialsarray {
    for ($i = 0; $i -lt $ArrayOfLogins.Count; $i++) {
        $Credentials += @(
        [pscustomobject]@{Title = ''; username = ''; password = '' }
        )    
    }
}
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
    #foreach ($client in $clients) {
    #if ($i -like $client ) {
    $toarray = $i.split(",")
    $toarray[0] = $toarray[0].replace('password:', '')
    $toarray[1] = $toarray[1].replace('title:', '')
    $toarray[2] = $toarray[2].replace('username:', '')
    #$index = $clients.IndexOf($client) - 1
    $Credentials += @(
        [pscustomobject]@{Title = $toarray[1]; username = $toarray[2]; password = $toarray[0] }
    )  
    #}
    #}
        
        
}
# Create Window
$Mainform = New-Object System.Windows.forms.Form
$Mainform.Text = 'DAMN - Applications'
$Mainform.Size = New-Object System.Drawing.Size(300, 600)
$Mainform.StartPosition = 'CenterScreen'
# Create IBM Notes Button
$IBMnotesButton = New-Object System.Windows.Forms.Button
$IBMnotesButton.Location = New-Object System.Drawing.Point(5, 30)
$IBMnotesButton.Size = New-Object System.Drawing.Size(150, 40)
$IBMnotesButton.Text = 'IBM Notes'
$Mainform.AcceptButton = $IBMnotesButton
$Mainform.Controls.Add($IBMnotesButton)
# Create Tox Button
if (Test-Path "C:\Program Files (x86)\Toxclient") {
    $ToxButton = New-Object System.Windows.Forms.Button
    $ToxButton.Location = New-Object System.Drawing.Point(5, 75)
    $ToxButton.Size = New-Object System.Drawing.Size(150, 40)
    $ToxButton.Text = 'TOX'
    $Mainform.AcceptButton = $ToxButton
    $Mainform.Controls.Add($ToxButton)
} else {
    [System.Windows.Forms.MessageBox]::Show( "Path to tox not found!" , "TOX Not Found")
}
$BlueZzzPath = ($pwd).Path + "\BlueZzz"
Write-Output $BlueZzzPath
Write-Output (Test-Path $BlueZzzPath)
if (Test-Path $BlueZzzPath) {
    $BlueZzzButton = New-Object System.Windows.Forms.Button
    $BlueZzzButton.Location = New-Object System.Drawing.Point(5, 120)
    $BlueZzzButton.Size = New-Object System.Drawing.Size(150, 40)
    $BlueZzzButton.Text = 'BlueZzz'
    $Mainform.AcceptButton = $BlueZzzButton
    $Mainform.Controls.Add($BlueZzzButton)
}
else {
    [System.Windows.Forms.MessageBox]::Show( "Please copy BlueZzz Folder To this Folder" , "BlueZzz Not Found")
}



$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(5, 10)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Choose App to logon to:'
$Mainform.Controls.Add($label)

$Mainform.Topmost = $true

# Event Handeling - Button Click
# Add Button event 
$IBMnotesButton.Add_Click(
    {    
        $i = $Credentials.title.IndexOf("IBM Notes")
        #[System.Windows.Forms.MessageBox]::Show( $Credentials[$i].title + " " + $Credentials[$i].username + " " + $Credentials[$i].password , "IBM Notes Credentials")
        WindowManager "Notes" $Credentials[$i].password
    }
)
if (Test-Path "C:\Program Files (x86)\Toxclient") {
    $ToxButton.Add_Click(
        {    
            $i = $Credentials.title.IndexOf("TOX")
            #[System.Windows.Forms.MessageBox]::Show( $Credentials[$i].title + " " + $Credentials[$i].username + " " + $Credentials[$i].password , "IBM Notes Credentials")
            WindowManager "TOX" $Credentials[$i].username $Credentials[$i].password
        }
    )
}
if (Test-Path $BlueZzzPath) {
    $BlueZzzButton.Add_Click(
        {    
            $i = $Credentials.title.IndexOf("IBM")
            #[System.Windows.Forms.MessageBox]::Show( $Credentials[$i].title + " " + $Credentials[$i].username + " " + $Credentials[$i].password , "IBM Notes Credentials")
            WindowManager "BlueZzz" $Credentials[$i].password
        }
    )
}

$Mainform.Add_Shown( { $ToxButton.Select() })
$resultofform = $Mainform.ShowDialog()

if ($resultofIBMnotesButton -eq [System.Windows.Forms.DialogResult]::OK) {
    # .".\WindowManager.ps1" 
       

}


