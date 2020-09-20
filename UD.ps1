$file = $args[0]
$newfile = (($pwd).path + "DAMN-new.exe")
[System.Windows.Forms.MessageBox]::Show( $file , "Replacing $file") 
Start-sleep -seconds 5
Copy-Item -Path $newfile -Destination $file.Replace("\$dir","") -Force