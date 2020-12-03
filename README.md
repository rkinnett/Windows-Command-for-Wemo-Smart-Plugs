# Windows-Command-for-Wemo-Smart-Plugs
A Windows batch script to detect and control Wemo smart plugs.  
  
## Requirements
Requires one or more Wemo switches registered to your network and pingable from your PC.  
  
Requires the **_curl_** command which is included in Windows 10 but not earlier versions.  If you're using an older version of Windows or your system is not up to date, you can download curl from here: https://curl.se/windows/.  The binary curl.exe file must be in your command path, either inside one of the directories listed in your %PATH% environment variable, or placed inside the same directory as this batch script.  
  
For troubleshooting purposes, if you know the IP address of your Wemo switch, you can test network accessibility from the curl command as follows (substitute your switch IP address):  `curl -silent http://192.188.1.100:49153/setup.xml`  
  
## Setup:
Download wemo.bat (click wemo.bat above, then right-click on the "RAW" button and select save-as) file and save it anywhere in your file system.  
  
## Running the tool:  
You can run this script form the command line (cmd.exe) or you can create a Windows shortcut to this file with arguments.  For example, you could create a shortcut called "Turn on lamp" with "wemo 192.168.1.100 on" as the target location, and give it a lightbulb icon!  
  
This script can get information about a single switch at a specified IP address, check the state of the switch, or turn it on or off.  
  
### Usage:  
```
wemo [instruction (info|check|state|on|off|scan)] [IPAddress1 (optional)] [IPAddress2 (optional)]
```
* Ordering of arguments isn't critical.  You can put the *instruction* 1as the first or last argument, or anywhere in between.  
* The **_info**, **_check_**, **_state_**, **_on_**, and **_off_** instructions require one IPAddress argument, the address of the target switch.  
* The **_scan_** instruciton requires zero or two IP address arguments.  
  * If *no* IP address arguments are provided, this script gets the host PC's local IP address and scans all addresses with same base, and suffix ranging from 2 to 254.  This full scan takes about 2 minutes to complete.
  * if *2* IP address arguments are provided, this script scans from the first address to the second, inclusively.  Scanning a limited range can be much faster than a full scan.
  
### Examples:  
```
wemo 192.168.1.100 on  
wemo 192.168.1.100 off  
wemo 192.168.1.100 check  
wemo check 192.168.1.100  
wemo scan  
wemo scan 192.168.1.100 192.168.1.120  
```
    
If you happen to hook a bunch of Christmas lights up to Wemo switches and use this script to turn them on and off in sequence to the tune of "Christmas Eve/Sarajevo", BY ALL MEANS PLEASE POST A VIDEO AND LET ME KNOW!  :)  
  
"With great power.." or somesuch. Don't be evil!  
