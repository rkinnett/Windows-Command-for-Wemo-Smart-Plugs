# Windows-Command-for-Wemo-Smart-Plugs
A Windows batch script to detect and control Wemo smart plugs.  
  
This script can scan your network for Wemo switches and display information about each detected switch, query a specific switch for information or state, or turn a specific switch on or off.  
  
## Requirements
Requires one or more Wemo switches registered to your network and pingable from your PC.  
  
Requires the **_curl_** command which is included in Windows 10 but not earlier versions.  If you're using an older version of Windows or your system is not up to date, you can download curl from here: https://curl.se/windows/.  The binary curl.exe file must be on your command path, either inside one of the directories listed in your PATH environment variable, or placed inside the same directory as this batch script.  
  
For troubleshooting purposes, if you know the IP address of your Wemo switch, you can test network accessibility from the curl command as follows (substitute your switch IP address):  
`curl -silent http://192.188.1.100:49153/setup.xml`  
  
## Setup:
Download wemo.bat from project links above, or right-click [here](https://github.com/rkinnett/Windows-Command-for-Wemo-Smart-Plugs/raw/main/wemo.bat "wemo.bat page"), select Save-as, and save wemo.bat anywhere you like.
  
## Running the tool:  
You can run this script form the command line (cmd.exe) or you can create a Windows shortcut to this file with arguments.  For example, you could create a shortcut called "Turn on lamp" with "C:\path\to\wemo.bat 192.168.1.100 on" as the target location (substituting the target IP address and full path to wemo.bat), and give it a lightbulb icon!    
  
### Usage:  
```
wemo [instruction (info|check|state|on|off|scan)] [IPAddress1 (optional)] [IPAddress2 (optional)]
```
* Ordering of arguments isn't critical.  You can put the *instruction* 1as the first or last argument, or anywhere in between.  
* The **_info_**, **_check_**, **_state_**, **_on_**, and **_off_** control and status instructions require one IPAddress argument, the address of the target switch.  
* The **_scan_** instruction requires zero or two IP address arguments.  
  * If *no* IP address arguments are provided, this script gets the host PC's local IP address and scans all addresses with same base, and suffix ranging from 2 to 254.  This full scan takes about 2 minutes to complete.
  * If *2* IP address arguments are provided, this script scans from the first address to the second, inclusively.  Scanning a limited range can be much faster than a full scan.
  * Scan results are not stored in any way.  Results are displayed as information only, to inform the user's selection of IP address(es) to use with control and status instructions.
  
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
