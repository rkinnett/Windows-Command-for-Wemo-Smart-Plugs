# Windows-Command-for-Wemo-Smart-Plugs
A Windows batch file to provide command-line control of any Wemo smart plug. Use this to turn a smart plug on or off or to check state.  

Tested with Wemo Smart Switch and Wemo Mini, but this should work with other Wemo smart plugs/switches as well.

## Requirements
Requires curl command which should be included in Windows 10.  
Otherwise, if you're using an older version of Windows or your system is not up to date, you can download curl from here:  https://curl.se/windows/

## Setup:
Simply place this batch file anywhere in your Windows file system and run it via cmd terminal or create your own Windows shortcuts.
  
Sorry, this script is not sophisticated enough to search for devices yet.. perhaps in a future version.  For now, you'll need to find out the IP address of your target switch by other means (e.g. your router's list of connected devices, Fing app, Wemo app, etc).  
  
## Running the tool:  
  
Usage:  
        wemo IPADDRESS [info|check|state|on|off]  
  
Examples:  
        wemo 192.168.1.100 on  
        wemo 192.168.1.100 off  
        wemo 192.168.1.100 check  
  
"With great power.." or somesuch. Don't be evil!
