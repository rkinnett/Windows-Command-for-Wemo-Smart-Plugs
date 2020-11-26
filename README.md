# Windows-Command-for-Wemo-Smart-Plugs
A Windows batch file to turn any Wemo Mini smart plug on or off or to check state.  Probably works with other Wemo smart plugs/switches as well.

Place this batch file anywhere in your Windows file system and run it via cmd terminal or create your Windows shortcuts.  Sorry, this script is not sophisticated enough to search for devices yet.  Perhaps in a future version.  For now, you'll need to find out the IP address of your target switch by other means (e.g. your router's list of connected devices, Fing app, Wemo app, etc).

Usage:  
        wemo IPADDRESS [info|check|state|on|off]  

Examples:  
        wemo 192.168.1.100 on  
        wemo 192.168.1.100 off  
        wemo 192.168.1.100 check  
