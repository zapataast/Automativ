del D:\IBI\WILDFLY\posrestarter.bat rem end omnox script duudagc file-iig ustgaj bna 
del D:\IBI\WILDFLY\pos_restarter_Service.ps1 rem ustgana
if not exist "D:\Scripts\Backup" mkdir D:\Scripts\Backup
net use "\\it.ajnets.com\itid\11. ServerPOS" /Persistent:yes /USER:"pos@altanjoloo.com" "Aa1234" 
copy "\\it.ajnets.com\itid\11. ServerPOS\pos_restarter_Service.ps1"  D:\Scripts\. /Y 
copy "\\it.ajnets.com\itid\11. ServerPOS\pos_res.vbs"  D:\Scripts\. /Y 
SET CC=%~dp0
Powershell.exe -windowstyle hidden -executionpolicy remotesigned -File %CC%pos_restarter_Service.ps1
