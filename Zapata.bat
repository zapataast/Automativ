@echo ==================================================================
@echo off  
echo ********************Zapata Script file***  version 3.1 ***********************

@ echo.  
echo Disk nii Vsgee oryyl (E , F , G , M) ?: 
set /p CC= 
@echo domaind holbox
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%CC%:\Final\INSTALL\name.ps1""' -Verb RunAs}"
pause
@ echo.
@ echo Real-time protector disabled
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%CC%:\Final\INSTALL\scriptdisable.ps1""' -Verb RunAs}"

@echo Firewall off xiij bna 
Advfirewall set allprofiles state off
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%CC%:\Final\INSTALL\firewall.ps1""' -Verb RunAs}"

@echo Netfx3 syylgaj bna
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%CC%:\Final\INSTALL\netfx3.ps1""' -Verb RunAs}"

@echo windows update disable xiigdej bna 
sc config wuauserv start= disabled
net stop wuauserv

xcopy "%CC%:\Final\ERP" "D:"  /Y /H /E /F /I
md C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Templates
xcopy "E:\Final\INSTALL\office_Settings\Normal.dotm" "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Templates\"  /Y /H /E /F /I
cscript %CC%:\Final\ERP\short.vbs


cd /d %CC%:\Final\INSTALL
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%CC%:\Final\INSTALL\fontv2.ps1""' -Verb RunAs}"
Silverlight_x64.exe /silent
@echo 2. Silverlight syyj dyyslaa. 
BraveSetup-x64.exe
@echo 3. Brave browser syyj dyyslaa. 
winrar-x64-561b1.exe /silent
@echo 4. winrar-x64-561b1 syyj dyyslaa.
unrar.vbs

@ echo.
@echo 5. VNC password [CTRL + C ] -- 8L7WE-XSDTZ-RWDZJ-3LB8Y-2YYWA   ----------------------------
@echo VNC it#2016 password-oo xiisen bol tsaashaa yawna yy !!!!!
vnc-E4_6_1-x86_x64_win32.exe 

cd /d C:\Program Files\RealVNC\VNC4\
vncconfig.exe
@echo 6. Kaspersky syylgaj bna.....
cd /d %CC%:\Final\INSTALL
FullinstallALTANJOLOOgroup.exe


cd /d %CC%:\Final\INSTALL
@echo 6. Office-16 Syylgaj bna ......
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%CC%:\Final\INSTALL\office_install.ps1""' -Verb RunAs}"


@echo 7. Diamond install 
cd /d %CC%:\Final\INSTALL\Diamond 5.0\SetupWizard && SetupWizard.exe

	
@echo 8. StoreManagement Install
cd /d %CC%:\Final\INSTALL\Diamond 5.0\SetupWizard 
SetupWizard.exe


PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%CC%:\Final\INSTALL\office_Settings\excel.ps1""' -Verb RunAs}"
@echo Real-time protector Enabling
rem PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%CC%:\Final\INSTALL\scriptenable.ps1""' -Verb RunAs}"


exit 

 