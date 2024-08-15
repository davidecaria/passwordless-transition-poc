$devices = Get-WmiObject -Class Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -eq 0 }
$deviceFound = $devices | Where-Object { $_.DeviceID -match "VID_058F&PID_6387" }

#First check to avoid looping even if the right target is not plugged
if($deviceFound) {
    
    #If the right device is found, we will constantly check it
    while($true) {

            #Looking for the right device
            $devices = Get-WmiObject -Class Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -eq 0 }
            $deviceFound = $devices | Where-Object { $_.DeviceID -match "VID_058F&PID_6387" }

            #If the device is found and still plugged, keep on going
            if($deviceFound) {
                "Device with ID 'VID_058F&PID_6387' is connected." | Out-File -Append -FilePath "C:\device_status.txt"
            } else {
                
                #Else, lock the screen and stop the script
                "Device with ID 'VID_058F&PID_6387' is not connected." | Out-File -Append -FilePath "C:\device_status.txt"
                Add-Type -TypeDefinition @"
                using System;
                using System.Runtime.InteropServices;

                public class LockScreen {
                    [DllImport("user32.dll", SetLastError = true)]
                    public static extern bool LockWorkStation();
                }
"@
                [LockScreen]::LockWorkStation()
                exit
            }

            Start-Sleep -Seconds 1
    }

}

