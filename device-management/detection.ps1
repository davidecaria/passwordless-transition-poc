$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like "pt-session-logoff-task"}

if($taskExists) {
  Write-Host "Success"
  Exit 0
} else {
  Exit 1
}
