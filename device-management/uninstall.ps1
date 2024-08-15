Unregister-ScheduledTask -TaskName "pt-session-logoff-task" -Confirm:$false

# Remove the files
Remove-Item "C:\Windows\Temp\pt-session-logoff-task.xml" -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\key-presence-detector.ps1" -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\key-presence-detector.exe" -ErrorAction SilentlyContinue
