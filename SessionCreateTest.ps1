#requires -version 3
$Time = [Int]Get-Date -UFormat "%s"
[Float]$Time = $Time/1000
Write-Output $Time
$command = "[System.Environment]::SetEnvironmentVariable('OPTS', $Time ,[System.EnvironmentVariableTarget]::User)"
Write-Output $command
Invoke-Expression "[System.Environment]::SetEnvironmentVariable('OPTS',$Time,[System.EnvironmentVariableTarget]::User)"
$envsession = Invoke-Expression "[System.Environment]::GetEnvironmentVariable('OPTS',[System.EnvironmentVariableTarget]::User)"
Write-Output ($envsession)