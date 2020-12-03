# Windows-Command-for-Wemo-Smart-Plugs
A Windows batch file to provide command-line control of any Wemo smart plug. Use this to turn a smart plug on or off or to check state.  

Tested with Wemo Smart Switch and Wemo Mini, but this should work with other Wemo smart plugs/switches as well.

## Requirements
Requires curl command which should be included in Windows 10.  
Otherwise, if you're using an older version of Windows or your system is not up to date, you can download curl from here:  https://curl.se/windows/

## Setup:
Simply download wemo.bat (click wemo.bat above, then right-click on the "RAW" button and select save-as) file and save it anywhere in your file system.
  
Sorry, this script is not sophisticated enough to search for devices yet.. perhaps in a future version.  For now, you'll need to find out the IP address of your target switch by other means (e.g. your router's list of connected devices, Fing app, Wemo app, etc).  
  
## Running the tool:  
You can run wemo.bat by double-clicking on the file or by calling it from cmd.exe.  Additionally, you can create Windows shortcuts to this file with arguments.  For example, you could create a shortcut called "Turn on lamp" with "wemo 192.168.1.100 on" as the target location, and give it a lightbulb icon!  
  
This script can get information about a switch at a specified IP address, check the state of the switch, or turn it on or off.  
  
This script can also scan your network for Wemo switches and display information about each detected switch.  If no arguments are provided with the scan instruction, the script gets your IP address then scans all IP addresses with the same first three octets, incrementing the fourth octet from 2 to 254.  Each IP address takes about half a second, so a full-range scan takes about 2 minutes.  If you happen to know the expected range of IP addresses then you can speed up the scan by specifying start and end IP addresses to check, as shown in the example below.  
  
Usage:  
        wemo [instruction (info|check|state|on|off|scan)] [IPAddress1 (optional)] [IPAddress1 (optional)]
  
Examples:  
        wemo 192.168.1.100 on  
        wemo 192.168.1.100 off  
        wemo 192.168.1.100 check  
        wemo check 192.168.1.100  
        wemo scan  
        wemo scan 192.168.1.100 192.168.1.120  
  
"With great power.." or somesuch. Don't be evil!  
  
If you happen to hook a bunch of Christmas lights up to Wemo switches and use this script to turn them on and off in sequence to the tune of "Christmas Eve/Sarajev", by all means PLEASE POST A VIDEO AND LET ME KNOW!  :)
