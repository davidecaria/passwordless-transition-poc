# Define the log file path
$logFilePath = "C:\Windows\Temp\operation_log.txt"

# Function to log messages
function Log-Message {
    param (
        [string]$message,
        [int]$returnCode
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $user = $env:USERNAME
    $logMessage = "$timestamp - User: $user - Message: $message - Return Code: $returnCode"
    Add-Content -Path $logFilePath -Value $logMessage
}

# Copy the XML file
try {
    Copy-Item ".\pt-session-logoff-task.xml" "C:\Windows\Temp"
    Log-Message "Copied pt-session-logoff-task.xml to C:\Windows\Temp" 0
} catch {
    Log-Message "Failed to copy pt-session-logoff-task.xml to C:\Windows\Temp" $_.Exception.HResult
}

# Copy the PowerShell script
try {
    Copy-Item ".\key-presence-detector.ps1" "C:\Windows\Temp"
    Log-Message "Copied key-presence-detector.ps1 to C:\Windows\Temp" 0
} catch {
    Log-Message "Failed to copy key-presence-detector.ps1 to C:\Windows\Temp" $_.Exception.HResult
}

# Copy the executable
try {
    Copy-Item ".\key-presence-detector.exe" "C:\Windows\Temp"
    Log-Message "Copied key-presence-detector.exe to C:\Windows\Temp" 0
} catch {
    Log-Message "Failed to copy key-presence-detector.exe to C:\Windows\Temp" $_.Exception.HResult
}

# Copy the install script
try {
    Copy-Item ".\install.ps1" "C:\Windows\Temp"
    Log-Message "Copied install.ps1 to C:\Windows\Temp" 0
} catch {
    Log-Message "Failed to copy install.ps1 to C:\Windows\Temp" $_.Exception.HResult
}

# Get the user account using quser
try {
    $quserOutput = quser
    Log-Message "quser command executed" 0
    Log-Message "quser output: $quserOutput" 0

    $principal = $quserOutput | Select-String -Pattern "Active" | ForEach-Object { 
        $_.ToString().Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)[0] 
    }
    Log-Message "Parsed principal from quser output: $principal" 0

    $principal = $principal -replace '[><]', ''
    Log-Message "Cleaned principal: $principal" 0
} catch {
    Log-Message "Failed to retrieve user account using quser" $_.Exception.HResult
    Log-Message "quser output: $quserOutput" 1
}

# Get the user account using WMI as a fallback
if (-not $principal) {
    try {
        $sessions = Get-WmiObject -Class Win32_LogonSession -Filter "LogonType = 10"
        Log-Message "WMI sessions retrieved: $sessions" 0

        foreach ($session in $sessions) {
            $user = Get-WmiObject -Class Win32_LoggedOnUser -Filter "Dependent = 'Win32_LogonSession.LogonId=$($session.LogonId)'"
            Log-Message "WMI user retrieved: $user" 0

            $principal = $user.Antecedent -replace '.*Domain="([^"]+)",Name="([^"]+)".*', '$2'
            Log-Message "Retrieved user account using WMI: $principal" 0
        }
    } catch {
        Log-Message "Failed to retrieve user account using WMI" $_.Exception.HResult
    }
}

# Register a new Scheduled Task using the XML
try {
    Register-ScheduledTask -xml (Get-Content C:\Windows\Temp\pt-session-logoff-task.xml | Out-String) -TaskName "pt-session-logoff-task" -TaskPath "\" -User $principal
    Log-Message "Registered Scheduled Task pt-session-logoff-task" 0
} catch {
    Log-Message "Failed to register Scheduled Task pt-session-logoff-task" $_.Exception.HResult
}

# Additional logging for debugging
try {
    $taskXmlContent = Get-Content C:\Windows\Temp\pt-session-logoff-task.xml | Out-String
    Log-Message "Task XML content: $taskXmlContent" 0
} catch {
    Log-Message "Failed to read Task XML content" $_.Exception.HResult
}

# Log environment details
try {
    $envDetails = Get-ChildItem Env:
    Log-Message "Environment details: $envDetails" 0
} catch {
    Log-Message "Failed to retrieve environment details" $_.Exception.HResult
}

# Check permissions
try {
    $whoami = whoami
    Log-Message "Current user: $whoami" 0
    $adminCheck = bool
    Log-Message "Is user an admin: $adminCheck" 0
} catch {
    Log-Message "Failed to check permissions" $_.Exception.HResult
}
