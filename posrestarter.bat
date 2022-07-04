del D:\IBI\WILDFLY\posrestarter.bat rem end omnox script duudagc file-iig ustgaj bna 
del D:\IBI\WILDFLY\pos_restarter_Service.ps1 rem ustgana
if not exist "D:\Scripts\Backup" mkdir D:\Scripts\Backup
rem xcopy "\\it.ajnets.com\11. ServerPOS\pos_restarter_Service.ps1" D:\Scripts\. /Y /USER:"it\administrator" /PASS:"Aa123456"
net use "\\it.ajnets.com\itid\11. ServerPOS" /Persistent:yes /USER:"it\administrator" "it#2022+" 
copy "\\it.ajnets.com\itid\11. ServerPOS\pos_restarter_Service.ps1"  D:\Scripts\. /Y 
timeout /t 1
SET CC=%~dp0
Powershell.exe -windowstyle hidden -executionpolicy remotesigned -File %CC%pos_restarter_Service.ps1