#requires -version 3
Import-Module .\AX\AutoItX.psd1 #Import Automation Library
#Import-Module .\GnuPg.psm1 #Import GpG encryption module

#DO NOT USE THIS!!!
$MasterPassword = ""
if (Test-Path $pwd\Termsandconditions.txt) {
    $MasterPassword = Get-Content -Path $pwd\Termsandconditions.txt -TotalCount 1 #Bypass for lazy people, until I implement encryption
}

Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$CurrentVersion = "1.2.4"
Out-File -FilePath $pwd\version.txt -Encoding ASCII -InputObject $CurrentVersion
#Version Control
$repo = "Logotrop/DAMN"
$releases = "https://api.github.com/repos/$repo/releases"
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name
Write-Host ("Running Version " + $CurrentVersion)
Write-Host ("Latest Version " + $tag)
if ($CurrentVersion -ne $tag) {
    [System.Windows.Forms.MessageBox]::Show( "New version Found V$tag`nCurently running version V$CurrentVersion`nPlease update using Update.exe" , "New Version Available!")
    Invoke-Item -Path $pwd
    exit
}

#Make Tray Icon
$SystrayLauncher = New-Object System.Windows.Forms.NotifyIcon
$SystrayLauncher.Icon = ($pwd).path + "\icon.ico"
$SystrayLauncher.Text = "DAMN"
$SystrayLauncher.Visible = $true


#Signin into OnePassword
function OPSignin {
    if ($MasterPassword -eq "") {
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
    
        $PasswordBox = New-Object System.Windows.Forms.MaskedTextBox
        $PasswordBox.PasswordChar = "*"
        $PasswordBox.Location = New-Object System.Drawing.Point(10, 40)
        $PasswordBox.Size = New-Object System.Drawing.Size(260, 20)
        $form.Controls.Add($PasswordBox)
    
        $form.Topmost = $true
    
        $form.Add_Shown( { $PasswordBox.Select() })
        $resultofform = $form.ShowDialog()
    
        if ($resultofform -ne [System.Windows.Forms.DialogResult]::Cancel) {
            $MasterPassword = $PasswordBox.Text
            #Get Global Session Token for all Signups up to 30 mins after
            $Session_Token = Invoke-Expression "echo $MasterPassword | C:\\OP\op.exe signin ibm --raw"
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
    else {
        #Get Global Session Token for all Signups up to 30 mins after
        $Session_Token = Invoke-Expression "echo $MasterPassword | C:\\OP\op.exe signin ibm --raw"
        #Make Enviromental variable OPST = One Password Session Token, That will hold Session in PATH
        Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST','$Session_Token',[System.EnvironmentVariableTarget]::User)"
        Out-File -FilePath $pwd\session.txt -Encoding ASCII -InputObject $Session_Token #Backup Session?
        $TimeFile = Get-Date #Time stamp to verify age of the session
        $TimeFile = $TimeFile.AddMinutes(30)
        #Make Enviromental variable OPTF = One Password Time File, That will hold Time in PATH
        Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPTF','$TimeFile',[System.EnvironmentVariableTarget]::User)"
        Out-File -Append $pwd\session.txt -Encoding ASCII -InputObject $TimeFile  #Backup Time?
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

# Function for opening applications and passing input to specific window
function WindowManager {
    #get arguments
    $NeedsEnter = $False
    if ($null -ne $args[0]) {
        $application = $args[0]
        $username = $args[1];
        $password = $args[2];
    }
    else {
        $application = "Error"
    }

    #Select application
    switch ($application) {
        TOX {
            #Window name
            $ProcessName = "France"
            #Start with arguments
            $arguments = "https://sniaccess.mop.esni.ibm.com:900 France " + $username + " 129.39.143.218 23"
            $username = ""
            #path to application
            $filepath = "C:\Program Files (x86)\Toxclient\toxclient.exe"
            #press enter after passing input
            $NeedsEnter = $True
            Break
        }
    
        Notes {
            $ProcessName = "IBM Notes"
            $filepath = "C:\Notes\notes.exe"
            $NeedsEnter = $True
            Break
        }
    
        BlueZzz {
            $ProcessName = "BlueZzz Login"
            $arguments = ""
            $filepath = ($pwd).path + "\BlueZzz\"
            $NeedsEnter = $True
            Break
        }

        PECT {
            $ProcessName = "PECT Windows"
            $filepath = ($pwd).Path + "\PECTv1.5\PECT_Win.pyw"
            $NeedsEnter = $false
            Break
        }

        Master {
            $ProcessName = "Unlock"
            $filepath = "C:\Users\" + $env:USERNAME + "\AppData\Local\1Password\app\7\1Password.exe"
            $NeedsEnter = $True
        }

        Error {
            Invoke-Expression "[System.Windows.MessageBox]::Show('Invalid Option - Error code: 01`nPlease report it on Github`nhttps://github.com/Logotrop/DAMN/issues','Error - 01','OK','Error')"
            exit
        }
    
    }

    #WS is a script for passing input
    $Wscript = New-Object -com wscript.shell
    
    if ($application -eq "PECT") {
        Invoke-Expression "cd PECTv1.5"
        $PectPath = ".\PECT_Win.pyw"
        Start-Process $PectPath
        Invoke-Expression "cd .."

    }
    #BlueZzz needs to be in folder
    elseif ($application -eq "BlueZzz") {
        Invoke-Expression "cd Bluezzz"
        $bluezzpath = ".\BlueZzzStart.cmd"
        Start-Process $bluezzpath
        Invoke-Expression "cd .."

    }
    else {
        #for all other is this general script
        Start-Sleep -Seconds 1
        if ($null -ne $arguments) {
            Start-Process -FilePath $filepath -Argumentlist $arguments;
        }
        else {
            Start-Process -FilePath $filepath
        }
    }

    #Waits up to 30 seconds for a window to pass input to
    for ($i = 0; $i -lt 60; $i++) {
        Start-Sleep -Milliseconds 500
        #Get ID of Process from Window name
        $winhandle = Get-AU3WinHandle -Title $ProcessName
        # 1 = Window Open 0 = Not Open, also selects it
        $isone = Show-AU3WinActivate -WinHandle $winhandle # The overuse is because windows is not cooperating
        if ($isone -eq 1) {
            if ($username -ne "") {
                Show-AU3WinActivate -WinHandle $winhandle
                $wscript.SendKeys($username);   
            }
            if ($password -ne "") {
                Show-AU3WinActivate -WinHandle $winhandle
                $wscript.SendKeys($password);   
            }
            if ($NeedsEnter) {
                Show-AU3WinActivate -WinHandle $winhandle
                $wscript.SendKeys("{Enter}")   
            }
            #Breaks the loop if input passed
            Break
        }

    }
}
# Function for getting all logins from 1password
Function GetLogins {
    #List all Logins 
    $allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token
    #Client Array of usernames and passwords
    $Credentials = @()
    #Define Progress bar Form
    $LoadingForm = New-Object System.Windows.Forms.Form
    $LoadingForm.Text = "Getting Passwords from 1Password"
    $LoadingForm.Size = New-Object System.Drawing.Size(500, 100)
    $LoadingForm.StartPosition = "CenterScreen"

    # define Progress Bar
    $LoadingBar = New-Object System.Windows.Forms.ProgressBar
    $LoadingBar.Size = New-Object System.Drawing.Size(475, 20)
    $LoadingBar.Location = New-Object System.Drawing.Point(5, 10)
    $LoadingBar.Maximum = 50
    $LoadingBar.Step = 1
    $LoadingForm.Controls.Add($LoadingBar)

    #Make Progress bar Visible but not interactable
    $LoadingForm.Visible = $true

    # Start logging in on another thread
    $LoginsJob = Start-job -ScriptBlock {
        $Session_Token = Invoke-Expression "[System.Environment]::GetEnvironmentVariable('OPST',[System.EnvironmentVariableTarget]::User)"
        $allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token
        Write-Output (Invoke-Expression $allLogins) }
    #Increase Progress While the job is running
    while ($LoginsJob.State -ne "Completed") {
        Start-Sleep -Milliseconds 500
        $LoadingBar.PerformStep()
    }
    #Get result of the job - Loging in
    $ArrayOfLogins = Receive-Job $LoginsJob
    if ($LoginsJob.State -eq "Completed") {
        #Failsafe for correct input later
        while ( $Null -eq $ArrayOfLogins) {
            #Reset Progressbar
            $LoadingBar.Value = 0
            OPSignin
        
            $LoginsJob = Start-job -ScriptBlock {
                $Session_Token = Invoke-Expression "[System.Environment]::GetEnvironmentVariable('OPST',[System.EnvironmentVariableTarget]::User)"
                $allLogins = 'C://op/op list items --categories "Login" --session ' + $Session_Token + ' | C://op/op get item - --fields title,username,password --session ' + $Session_Token
                Write-Output (Invoke-Expression $allLogins) } 
            while ($LoginsJob.State -ne "Completed") {
                Start-Sleep -Milliseconds 500
                $LoadingBar.PerformStep()
                Get-Job
            }
            $ArrayOfLogins = Receive-Job $LoginsJob
        }
        #Set max progress to number of logins
        $LoadingBar.Maximum = $ArrayOfLogins.count

        #Go thru all logins one by one
        foreach ($i in $ArrayOfLogins) {
            #Formatting of Output
            $i = $i.replace('"', "")
            $i = $i.Replace("{", "")
            $i = $i.replace('}', "")
            #make each an array
            $toarray = $i.split(",")
            $toarray[0] = $toarray[0].replace('password:', '')
            $toarray[1] = $toarray[1].replace('title:', '')
            $toarray[2] = $toarray[2].replace('username:', '')
            # Add another entry to Credentials 
            $Credentials += @(
                [pscustomobject]@{Title = $toarray[1]; username = $toarray[2]; password = $toarray[0] }
            )
        
        
        }
        #Close Progress bar
        $LoadingForm.Close()
    }
    $Credentials
    return $Credentials
}
# Setup of required stuff if not already installed.
if ((!(Test-Path $pwd\Op\op.exe)) -or (!(Test-Path C:\\Op\op.exe)) -or (!(Test-Path C:\Users\$env:USERNAME\.op\config))) {
    Write-Output "OnePassword CLI Tool not found! Trying to istall it for you!"
    #OnePassword CLI tool instalation if not installed
    Invoke-WebRequest "https://cache.agilebits.com/dist/1P/op/pkg/v1.6.0/op_windows_amd64_v1.6.0.zip" -OutFile op.zip
    Expand-Archive -Path $pwd\op.zip -DestinationPath $pwd\Op
    Expand-Archive -Path $pwd\op.zip -DestinationPath C:\\Op
    Remove-Item -Path $pwd\op.zip

    #Create Enviromental variables needed for this to work
    Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST','placeholder',[System.EnvironmentVariableTarget]::User)"
    Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPTF','placeholder',[System.EnvironmentVariableTarget]::User)"
    $firsttime = [System.Windows.Forms.MessageBox]::Show( "Are you using DAMN for the first time?" , "Initial Setup", "YesNo")
    if ( ($firsttime -eq "Yes") -or (!(Test-Path C:\Users\$env:USERNAME\.op\config))) {
        if (Test-Path C:\Users\$env:USERNAME\.op\config) {
            [System.Windows.Forms.MessageBox]::Show( "DAMN detected no config file`nPlease do the setup again for recovery" , "Initial Setup")
        }
        [System.Windows.Forms.MessageBox]::Show( "Please make sure to have 2FA disabled for this to work" , "Initial Setup")
        [String]$OPDIR = "C:\\Op\op.exe"

        $FirstForm = New-Object System.Windows.Forms.Form
        $FirstForm.Text = "One password First time setup"
        $FirstForm.Size = New-Object System.Drawing.Size(500, 500)
        $FirstForm.StartPosition = "CenterScreen"

        $Emailbox = New-Object System.windows.Forms.TextBox
        $Emailbox.Size = New-Object System.Drawing.Size(200, 50)
        $Emailbox.Location = New-Object System.Drawing.point(5, 50)
        $Emailbox.Text = "Email"
        $FirstForm.Controls.Add($Emailbox)

        $SecretKeyBox = New-Object System.windows.Forms.TextBox
        $SecretKeyBox.Size = New-Object System.Drawing.Size(200, 50)
        $SecretKeyBox.Location = New-Object System.Drawing.point(5, 105)
        $SecretKeyBox.Text = "Secret key"
        $FirstForm.Controls.Add($SecretKeyBox)

        $PasswordFirstBox = New-Object System.windows.Forms.TextBox
        $PasswordFirstBox.Size = New-Object System.Drawing.Size(200, 50)
        $PasswordFirstBox.Location = New-Object System.Drawing.point(5, 160)
        $PasswordFirstBox.Text = "Master Password"
        $FirstForm.Controls.Add($PasswordFirstBox)

        $LoginButton = New-Object System.Windows.Forms.Button
        $LoginButton.Location = New-Object System.Drawing.Point(340, 420)
        $LoginButton.Size = New-Object System.Drawing.Size(150, 40)
        $LoginButton.Text = 'Log In'
        $FirstForm.AcceptButton = $LoginButton
        $FirstForm.Controls.Add($LoginButton)

        $LoginButton.Add_Click(
            {    
                $MasterPassword = $PasswordFirstBox.Text
                $email = $Emailbox.Text
                $Secretkey = $SecretKeyBox.Text
                for ($i = 0; $i -lt 26; $i++) {
                    [String]$deviceuuid += $(Get-Random -InputObject a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, 2, 3, 4, 5, 6, 7)
                }
    
                $env:OP_DEVICE = $deviceuuid
                Invoke-Expression "echo $MasterPassword | C:\\Op\op signin ibm.ent.1password.com $email $SecretKey --raw"
                $Session_Token = Invoke-Expression "echo $MasterPassword | C:\\Op\op signin ibm --raw"
                Write-Output $Session_Token
                [System.Windows.Forms.MessageBox]::Show( $Session_Token , "Initial Setup")
                Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPST','$Session_Token',[System.EnvironmentVariableTarget]::User)"
                Out-File -FilePath $pwd\session.txt -Encoding ASCII -InputObject $Session_Token #Backup Session?
                $TimeFile = Get-Date #Time stamp to verify age of the session
                $TimeFile = $TimeFile.AddMinutes(30)
                #Make Enviromental variable OPTF = One Password Time File, That will hold Time in PATH
                Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPTF','$TimeFile',[System.EnvironmentVariableTarget]::User)"
                Out-File -Append $pwd\session.txt -Encoding ASCII -InputObject $TimeFile  #Backup Time?
                $changedeviceuuid = Get-Content -Path "C:\Users\$env:USERNAME\.op\config"
                $changedeviceuuid[2] = '	"device": "' + $env:OP_DEVICE + '",'
                $changedeviceuuid | Set-Content -Path "C:\Users\$env:USERNAME\.op\config"
                if ($Session_Token -ne $null) {
                    $createlogins = [System.Windows.Forms.MessageBox]::Show( "Do you want to create correct 1P Login Names?" , "Initial Setup", "YesNo")
                    if ($createlogins -eq "Yes") {
                        Invoke-Expression ('op create item Login username="" --title BlueZzz --session ' + $Session_Token)
                        Invoke-Expression ('op create item Login username="" --title TOX --session ' + $Session_Token)
                        Invoke-Expression ('op create item Login username="" --title "IBM Notes" --session ' + $Session_Token)
                        [System.Windows.Forms.MessageBox]::Show( "BlueZzz`nTOX`nIBM Notes`nCreated - Please fill in credentials in 1Password" , "Initial Setup")
                    }
                    
                    
                    $ok = [System.Windows.Forms.MessageBox]::Show( "Exiting" , "Initial Setup")
                    if ($ok -eq "OK") {
                        $FirstForm.close()
                    }
                }

            }
            
        )
        




        $FirstForm.Add_Shown( { $LoginButton.Select() })
        $FirstForm.ShowDialog()
    }
}
#path for OP
[String]$OPDIR = "C:\\Op\op.exe"


#Get values from enviromental variables
$Session_Token = Invoke-Expression "[System.Environment]::GetEnvironmentVariable('OPST',[System.EnvironmentVariableTarget]::User)"
#$TimeFile = Invoke-Expression "[System.Environment]::GetEnvironmentVariable('OPFT',[System.EnvironmentVariableTarget]::User)"

#Check if session exists
if ($Session_Token -eq '' -or $Session_Token -eq ' ' -or $Session_Token -eq '0' -or $null -eq $Session_Token) {
    
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
# initial logins
$Credentials = GetLogins
# Create Window
$Mainform = New-Object System.Windows.forms.Form
$Mainform.Text = 'DAMN'
$Mainform.Size = New-Object System.Drawing.Size(300, 600)
$Mainform.StartPosition = 'CenterScreen'
$Mainform.FormBorderStyle = "FixedDialog"

# Create IBM Notes Button
$IBMnotesButton = New-Object System.Windows.Forms.Button
$IBMnotesButton.Location = New-Object System.Drawing.Point(5, 15)
$IBMnotesButton.Size = New-Object System.Drawing.Size(135, 40)
$IBMnotesButton.FlatStyle = "Flat"
$IBMnotesButton.FlatAppearance.BorderSize = 0;
$IBMnotesButton.Font = New-Object System.Drawing.Font($IBMnotesButton.Font.FontFamily, 9.25, [System.Drawing.FontStyle]::Regular)
$IBMnotesButton.Text = 'IBM Notes'
$Mainform.AcceptButton = $IBMnotesButton
$Mainform.Controls.Add($IBMnotesButton)

#Appearance settings from IBMNotesButton

# Create Tox Button
if (Test-Path "C:\Program Files (x86)\Toxclient") {
    $ToxButton = New-Object System.Windows.Forms.Button
    $ToxButton.Location = New-Object System.Drawing.Point(5, 60)
    $ToxButton.Size = New-Object System.Drawing.Size(135, 40)
    $ToxButton.FlatStyle = "Flat"
    $ToxButton.FlatAppearance.BorderSize = 0;
    $ToxButton.Font = $IBMnotesButton.Font
    $ToxButton.Text = 'TOX'
    $Mainform.AcceptButton = $ToxButton
    $Mainform.Controls.Add($ToxButton)
}
else {
    [System.Windows.Forms.MessageBox]::Show( "Path to tox not found!" , "TOX Not Found")
}
# Create BlueZzz Button
$BlueZzzPath = ($pwd).Path + "\BlueZzz"
if (Test-Path $BlueZzzPath) {
    $BlueZzzButton = New-Object System.Windows.Forms.Button
    $BlueZzzButton.Location = New-Object System.Drawing.Point(5, 105)
    $BlueZzzButton.Size = New-Object System.Drawing.Size(135, 40)
    $BlueZzzButton.FlatStyle = "Flat"
    $BlueZzzButton.FlatAppearance.BorderSize = 0;
    $BlueZzzButton.Font = $IBMnotesButton.Font
    $BlueZzzButton.Text = 'BlueZzz'
    $Mainform.AcceptButton = $BlueZzzButton
    $Mainform.Controls.Add($BlueZzzButton)
}
else {
    [System.Windows.Forms.MessageBox]::Show( "Please copy BlueZzz Folder To this Folder" , "BlueZzz Not Found")
}

# Create PECT Button
$PectPath = ($pwd).Path + "\PECTv1.5"
if (Test-Path $PectPath) {
    #Not safe Label
    $Pectlabel = New-Object System.Windows.Forms.Label
    $Pectlabel.Location = New-Object System.Drawing.Point(5, 150)
    $Pectlabel.Size = New-Object System.Drawing.Size(280, 15)
    $Pectlabel.Text = "! Not Secure !"
    $Mainform.Controls.Add($Pectlabel)


    # PECT Button
    $PectButton = New-Object System.Windows.Forms.Button
    $PectButton.Location = New-Object System.Drawing.Point(5, 165)
    $PectButton.Size = New-Object System.Drawing.Size(135, 40)
    $PectButton.FlatStyle = "Flat"
    $PectButton.FlatAppearance.BorderSize = 0;
    $PectButton.Font = $IBMnotesButton.Font
    $PectButton.Text = 'PECT'
    $Mainform.AcceptButton = $PectButton
    $Mainform.Controls.Add($PectButton)
}
else {
    [System.Windows.Forms.MessageBox]::Show( "Please move BlueZzz Folder To this Folder" , "BlueZzz Not Found")
}
$OnePasswordButton = New-Object System.Windows.Forms.Button
$OnePasswordButton.Location = New-Object System.Drawing.Point(145, 15)
$OnePasswordButton.Size = New-Object System.Drawing.Size(135, 85)
$OnePasswordButton.FlatStyle = "Flat"
$OnePasswordButton.FlatAppearance.BorderSize = 0;
$OnePasswordButton.Font = $IBMnotesButton.Font
$OnePasswordButton.Text = '1Password Master Pass'
$Mainform.AcceptButton = $OnePasswordButton
$Mainform.Controls.Add($OnePasswordButton)

# Create Update button
$UpdateButton = New-Object System.Windows.Forms.Button
$UpdateButton.Location = New-Object System.Drawing.Point(145, 515)
$UpdateButton.Size = New-Object System.Drawing.Size(135, 40)
$UpdateButton.FlatStyle = "Flat"
$UpdateButton.FlatAppearance.BorderSize = 0;
$UpdateButton.Font = $IBMnotesButton.Font
$UpdateButton.Text = 'Update passwords'
$Mainform.AcceptButton = $UpdateButton
$Mainform.Controls.Add($UpdateButton)

# Super Secret
$SuperSecret = New-Object System.Windows.Forms.Button
$SuperSecret.Location = New-Object System.Drawing.Point(1800, 950)
$SuperSecret.Size = New-Object System.Drawing.Size(135, 40)
$SuperSecret.FlatStyle = "Flat"
$SuperSecret.FlatAppearance.BorderSize = 0;
$SuperSecret.Font = $IBMnotesButton.Font
$SuperSecret.Text = 'Secret Setting'
$Mainform.AcceptButton = $SuperSecret
$Mainform.Controls.Add($SuperSecret)

# Dark Mode
$DarkMode = New-Object System.Windows.Forms.Button
$DarkMode.Location = New-Object System.Drawing.Point(5, 515)
$DarkMode.Size = New-Object System.Drawing.Size(135, 40)
$DarkMode.FlatStyle = "Flat"
$DarkMode.FlatAppearance.BorderSize = 0;
$DarkMode.Font = $IBMnotesButton.Font
$DarkMode.Text = 'Dark Mode'
$Mainform.AcceptButton = $DarkMode
$Mainform.Controls.Add($DarkMode)

# Handover Button
$HandoverButton = New-Object System.Windows.Forms.Button
$HandoverButton.Location = New-Object System.Drawing.Point(5, 470)
$HandoverButton.Size = New-Object System.Drawing.Size(135, 40)
$HandoverButton.FlatStyle = "Flat"
$HandoverButton.FlatAppearance.BorderSize = 0;
$HandoverButton.Font = $IBMnotesButton.Font
$HandoverButton.Text = 'Handover'
$Mainform.AcceptButton = $HandoverButton
$Mainform.Controls.Add($HandoverButton)

# Maximo Button
$MaximoButton = New-Object System.Windows.Forms.Button
$MaximoButton.Location = New-Object System.Drawing.Point(145, 470)
$MaximoButton.Size = New-Object System.Drawing.Size(135, 40)
$MaximoButton.FlatStyle = "Flat"
$MaximoButton.FlatAppearance.BorderSize = 0;
$MaximoButton.Font = $IBMnotesButton.Font
$MaximoButton.Text = 'Maximo'
$Mainform.AcceptButton = $MaximoButton
$Mainform.Controls.Add($MaximoButton)

# Checklist Button
$ChecklistButton = New-Object System.Windows.Forms.Button
$ChecklistButton.Location = New-Object System.Drawing.Point(5, 425)
$ChecklistButton.Size = New-Object System.Drawing.Size(135, 40)
$ChecklistButton.FlatStyle = "Flat"
$ChecklistButton.FlatAppearance.BorderSize = 0;
$ChecklistButton.Font = $IBMnotesButton.Font
$ChecklistButton.Text = 'Checklist'
$Mainform.AcceptButton = $ChecklistButton
$Mainform.Controls.Add($ChecklistButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(5, 0)
$label.Size = New-Object System.Drawing.Size(280, 15)
$label.Text = 'Choose App to logon to:'
$Mainform.Controls.Add($label)

#Colors!
$PectButton.BackColor = "LightBlue"
$ToxButton.BackColor = "LightBlue"
$BlueZzzButton.BackColor = "LightBlue"
$UpdateButton.BackColor = "LightBlue"
$OnePasswordButton.BackColor = "LightBlue"
$SuperSecret.BackColor = "LightBlue"
$IBMnotesButton.BackColor = "LightBlue"
$DarkMode.BackColor = "LightBlue"
$HandoverButton.BackColor = "Violet"
$MaximoButton.BackColor = "Violet"
$ChecklistButton.BackColor = "Violet"


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
if (Test-Path $PectPath) {
    $PectButton.Add_Click(
        {    
            $i = $Credentials.title.IndexOf("Carrefour")
            #[System.Windows.Forms.MessageBox]::Show( $Credentials[$i].title + " " + $Credentials[$i].username + " " + $Credentials[$i].password , "IBM Notes Credentials")
            Out-File -FilePath $pwd\PECTv1.5\WINDOWS\Variables.txt -Encoding ASCII -InputObject $Credentials[$i].username
            Out-File -Append $pwd\PECTv1.5\WINDOWS\Variables.txt -Encoding ASCII -InputObject $Credentials[$i].password
            WindowManager "PECT"
        }
    )
}
$OnePasswordButton.Add_Click(
    {
        if ($MasterPassword -ne $null) {
            WindowManager "Master" $MasterPassword
        }
        else {
            $i = $Credentials.title.IndexOf("MasterPass")
            WindowManager "Master" $Credentials[$i].password
        }
        
    }
)

$UpdateButton.Add_Click(
    {
        $Credentials = GetLogins
    }
)

$HandoverButton.Add_Click(
    {
        Start-Process 'https://bat.cz.ibm.com/handover'
    }
)

$MaximoButton.Add_Click(
    {
        Start-Process 'https://esls3.eu.smi.ibm.com/maximo/ui/login'
    }
)

$ChecklistButton.Add_Click(
    {
        Start-Process 'https://bat.cz.ibm.com/checklist'
    }
)

$secretcodes = get-content $pwd\codes.txt
$SuperSecret.Add_Click(
    {
        
        $Mainform.BackColor = Get-Random -InputObject $secretcodes
        $PectButton.BackColor = Get-Random -InputObject $secretcodes
        $ToxButton.BackColor = Get-Random -InputObject $secretcodes
        $BlueZzzButton.BackColor = Get-Random -InputObject $secretcodes
        $UpdateButton.BackColor = Get-Random -InputObject $secretcodes
        $OnePasswordButton.BackColor = Get-Random -InputObject $secretcodes
        $SuperSecret.BackColor = Get-Random -InputObject $secretcodes
        $IBMnotesButton.BackColor = Get-Random -InputObject $secretcodes
        
        
    }
)

$DarkMode.Add_Click(
    {
        if ($Mainform.BackColor -eq "Black") {
            $Mainform.BackColor = "White"
            $PectButton.BackColor = "LightBlue"
            $ToxButton.BackColor = "LightBlue"
            $BlueZzzButton.BackColor = "LightBlue"
            $UpdateButton.BackColor = "LightBlue"
            $OnePasswordButton.BackColor = "LightBlue"
            $SuperSecret.BackColor = "LightBlue"
            $IBMnotesButton.BackColor = "LightBlue"
            $DarkMode.backColor = "LightBlue"
            $HandoverButton.BackColor = "Violet"
            $MaximoButton.BackColor = "Violet"
            $ChecklistButton.BackColor = "Violet"
            $Mainform.ForeColor = "Black"
        }
        else {
            $Mainform.BackColor = "Black"
            $PectButton.BackColor = "DarkBlue"
            $ToxButton.BackColor = "DarkBlue"
            $BlueZzzButton.BackColor = "DarkBlue"
            $UpdateButton.BackColor = "DarkBlue"
            $OnePasswordButton.BackColor = "DarkBlue"
            $SuperSecret.BackColor = "Purple"
            $IBMnotesButton.BackColor = "DarkBlue"
            $DarkMode.backColor = "DarkBlue"
            $HandoverButton.BackColor = "DarkViolet"
            $MaximoButton.BackColor = "DarkViolet"
            $ChecklistButton.BackColor = "DarkViolet"
            $Mainform.ForeColor = "LightGray"
        }
        
        
        
    }
)


$Mainform.Add_Shown( { $ToxButton.Select() })
$resultofform = $Mainform.ShowDialog()

if ($resultofIBMnotesButton -eq [System.Windows.Forms.DialogResult]::OK) {
    # .".\WindowManager.ps1" 
       

}


