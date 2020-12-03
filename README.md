# Windows-Command-for-Wemo-Smart-Plugs
A Windows batch script to detect and control Wemo smart plugs.  
  
## Requirements
Requires curl command which is included in Windows 10 but not earlier versions.  If you're using an older version of Windows or your system is not up to date, you can download curl from here: https://curl.se/windows/.  The binary curl.exe must be in your command path, either inside one of the directories listed in your %PATH% environment variable, or placed inside the same directory as this batch script.  

Requires one or more Wemo switches registered to your network and pingable from your PC.

## Setup:
Download wemo.bat (click wemo.bat above, then right-click on the "RAW" button and select save-as) file and save it anywhere in your file system.  
  
## Running the tool:  
You can run this script form the command line (cmd.exe) or you can create a Windows shortcut to this file with arguments.  For example, you could create a shortcut called "Turn on lamp" with "wemo 192.168.1.100 on" as the target location, and give it a lightbulb icon!  
  
This script can get information about a single switch at a specified IP address, check the state of the switch, or turn it on or off.  
  
This script can also scan your network for Wemo switches and display information about each detected switch.  If no arguments are provided with the scan instruction, the script gets your IP address then scans all IP addresses with the same base address (same first three octets), incrementing the fourth octet from 2 to 254.  Each IP address takes about half a second to check and a full-range scan takes about 2 minutes.  If you happen to know the expected range of IP addresses then you can speed up the scan by specifying start and end IP addresses to check, as shown in the example below.  
  
### Usage:  
        wemo [instruction (info|check|state|on|off|scan)] [IPAddress1 (optional)] [IPAddress1 (optional)]
  
### Examples:  
        wemo 192.168.1.100 on  
        wemo 192.168.1.100 off  
        wemo 192.168.1.100 check  
        wemo check 192.168.1.100  
        wemo scan  
        wemo scan 192.168.1.100 192.168.1.120  
    
If you happen to hook a bunch of Christmas lights up to Wemo switches and use this script to turn them on and off in sequence to the tune of "Christmas Eve/Sarajevo", BY ALL MEANS PLEASE POST A VIDEO AND LET ME KNOW!  :)  
  
"With great power.." or somesuch. Don't be evil!  
