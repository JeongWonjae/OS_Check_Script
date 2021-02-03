@ECHO OFF

ECHO.                                 									> %COMPUTERNAME%_result.txt
ECHO [Scan Vulnerability for Windows Server]               				>> %COMPUTERNAME%_result.txt
ECHO Target : Windows Server 2016(EN version)            				>> %COMPUTERNAME%_result.txt
ECHO Created by : Jeong Wonjae, Kim Seokju				            	>> %COMPUTERNAME%_result.txt
ECHO Check Result Range : ��ȣ/���/���� ���� �ʿ�/���ͺ� �ʿ�						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO [+]batch start
ECHO [+]create %COMPUTERNAME%_result.txt

ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

REM *****Make Config File*****
secedit /export /cfg securityPolicy.txt > nul

REM *****Start Check*****
ECHO [+]W01 start
ECHO �� W-01 : Administrator ���� �̸� �ٲٱ� 									>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Administrator Default ���� �̸��� ������ ��� ��ȣ					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
net localgroup administrators > NUL    									>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 net localgroup administrators | find /i "Account active"    >> %COMPUTERNAME%_result.txt
net user Administrator | find /i "Account active" | find /i "Yes" > NUL   		>> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 ECHO �� ��� : ��ȣ 										>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 ECHO �� ��� : ��� 									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W01 end

ECHO [+]W02 start
ECHO �� W-02 : Guest ���� ���� 												>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Guest ������ ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ 								>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
net user guest > NUL   													>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 net user guest | find "Account active"  			>> %COMPUTERNAME%_result.txt
net user guest | find "Account active" | find "Yes">NUL    				>> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 ECHO �� ��� : ��ȣ 										>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 ECHO �� ��� : ���  									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W02 end

ECHO [+]W03 start
ECHO �� W-03 : ���ʿ��� ���� ���� 												>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ���ʿ��� ������ �������� �ʴ� ��� ��ȣ 									>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
net user 																>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ�							 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W03 end

ECHO [+]W04 start
ECHO �� W-04 : ���� ��� �Ӱ谪 ����											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ���� ��� �Ӱ谪�� 5 ������ ������ �����Ǿ� �ִ� ��� ��ȣ 					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
net accounts | findstr /l /C:"Lockout threshold"  						>> %COMPUTERNAME%_result.txt
net accounts | findstr /l /C:"Lockout threshold" > chkLOCK.txt
FOR /f "tokens=3 delims= " %%a IN (chkLOCK.txt) DO SET chkLOCK=%%a
IF "%chkLOCK%"=="Never" (
    ECHO �� ��� : ���   													>> %COMPUTERNAME%_result.txt
    GOTO END04
)
IF %chkLOCK% LEQ 5 ECHO �� ��� : ��ȣ   									>> %COMPUTERNAME%_result.txt
IF NOT %chkLOCK% LEQ 5 ECHO �� ��� : ���   								>> %COMPUTERNAME%_result.txt
:END04
DEL chkLOCK.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W04 end

ECHO [+]W05 start
ECHO �� W-05 : �ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ���� ���� 							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "�ص� ������ ��ȣȭ�� ����Ͽ� ��ȣ ����" ��å�� "��� �� ��"���� �Ǿ� �ִ� ��� ��ȣ 	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find /i "PasswordComplexity"    				>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find /i "PasswordComplexity=1" > NUL
IF ERRORLEVEL 1 ECHO �� ��� : ��ȣ  										>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 ECHO �� ��� : ���  									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W05 end

ECHO [+]W06 start
ECHO �� W-06 : ������ �׷쿡 �ּ����� ����� ���� 									>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Administrators �׷��� �������� 1�� ���Ϸ� �����ϰų�, ���ʿ��� ������ ������ �������� �ʴ� ��� ��ȣ	  >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
net localgroup administrators > NUL  									>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ�  													>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W06 end

ECHO [+]W07 start
ECHO �� W-07 : ���� ���� �� ����� �׷� ���� 										>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �Ϲ� ���� ���丮�� ���ų� ���� ���丮 ���� ���ѿ� Everyone ������ ���� ��� "��ȣ"	    >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
net share | findstr ":" > getFName1.txt
net share | findstr ":" 												>> %COMPUTERNAME%_result.txt
for /F "tokens=2 delims= " %%L in (getFName1.txt) do (
   ECHO %%L >> getFName2.txt 
)
ECHO. 																	>> %COMPUTERNAME%_result.txt
for /F "tokens=1" %%K in (getFName2.txt) do (
   icacls %%K > chkPermission.txt
   icacls %%K 															>> %COMPUTERNAME%_result.txt
)
type "chkPermission.txt" | findstr "EVERYONE" > nul
IF ERRORLEVEL 1 ECHO �� ��� : ��ȣ 										>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 ECHO �� ��� : ��� 									>> %COMPUTERNAME%_result.txt

DEL getFName1.txt
DEL getFName2.txt
DEL chkPermission.txt

ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W07 end

ECHO [+]W08 start
ECHO �� W-08 : �ϵ��ũ �⺻ ���� ���� 										>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ������Ʈ���� AutoShareServer(WinNT:AutoShareWks)�� 0�̸� �⺻ ������ �������� �ʴ� ��� "��ȣ"	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
REG query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" >> %COMPUTERNAME%_result.txt
REG query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" | find /I "AutoShareServer" > chkReg.txt >> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 0 (
	ECHO Not Exist 'AutoShareServer' Registry value.					>> %COMPUTERNAME%_result.txt
	ECHO �� ��� : ���														>> %COMPUTERNAME%_result.txt
	GOTO END08
)
type chkReg.txt | find "1" > nul
IF NOT ERRORLEVEL 0 (
	ECHO �� ��� : ��ȣ	
	GOTO END08
)
ECHO 'AutoShareServer' is set '0'										>> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 0 ECHO �� ��� : ���
:END08
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W08 end

ECHO [+]W09 start
ECHO �� W-09 : ���ʿ��� ���� ���� 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �Ϲ������� ���ʿ��� ���񽺰� �����Ǿ� �ִ� ��� "��ȣ"	    			>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
SET chkServices=0
net start > net_start.txt
TYPE net_start.txt | findstr "Alerter ClipBook Messenger" > nul
IF NOT ERRORLEVEL 1 (
	SET chkServices=1
	ECHO Exist 'Alerter ClipBook Messenger' that unnecessary service.	>> %COMPUTERNAME%_result.txt
)
TYPE net_start.txt | findstr "Simple TCP/IP Services" > nul
IF NOT ERRORLEVEL 1 (
	SET chkServices=1
	ECHO Exist 'Simple TCP/IP Services' that unnecessary service.	>> %COMPUTERNAME%_result.txt
)
TYPE net_start.txt | findstr /I "Alerter ClipBook Messenger Simple" > nul
IF NOT ERRORLEVEL 1 (
	SET chkServices=1
	ECHO Exist 'Alerter ClipBook Messenger Simple' that unnecessary service.	>> %COMPUTERNAME%_result.txt
)

IF %chkServices%==1 (
  GOTO BAD09
)
:GOOD09
ECHO �� ��� : ��ȣ 														>> %COMPUTERNAME%_result.txt
GOTO END09
:BAD09
ECHO �� ��� : ���	 														>> %COMPUTERNAME%_result.txt
:END09
DEL net_start.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W09 end

ECHO [+]W10 start
ECHO �� W-10 : IIS ���� ���� ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : IIS ���񽺰� �ʿ����� �ʾ� �̿����� �ʴ� ��� ��ȣ       					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
sc query | findstr /i "iis" > nul
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" > nul
IF ERRORLEVEL 1 GOTO IISSkip
IF NOT ERRORLEVEL 1 GOTO IISNotSkip
:IISSkip
ECHO Not exist IIS Service.   											>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
GOTO IISNotExist
:IISNotSkip
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "String" >> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ�               										>> %COMPUTERNAME%_result.txt
ECHO [+]W10 end                     
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W11 start            
ECHO �� W-11 : ���丮 ������ ����                								>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "���丮 �˻�" üũ���� ���� ��� ��ȣ               					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO IIS Manager --/ Web Sites --/ Error pages --/ Edit feature Settgins --/ check "Custom error pages" >> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ�               									>> %COMPUTERNAME%_result.txt
ECHO [+]W11 end                           
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W12 start            
ECHO �� W-12 : IIS CGI ���� ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ش� ���͸� Everyone�� ��� ����, ���� ����, ���� ������ �ο����� ���� ��� ��ȣ >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
ECHO Default IIS Directory        										>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "PathWWWRoot" >> %COMPUTERNAME%_result.txt
ECHO Default CGI Directory : C:\inetpub\scripts 						>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO CGI Directory Properties --/ Security --/ Edit --/ Check "Everyone" Permssion set nothing >> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ�               									>> %COMPUTERNAME%_result.txt
ECHO [+]W12 end                           
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W13 start            
ECHO �� W-13 : IIS ���� ���丮 ���� ����                						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ���� �н� ����� ������ ��� ��ȣ 									>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO IIS Manager --/ Web Sites(ALL) --/ ASP --/ Enable Parent Path --/ set "False" >> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ�               									>> %COMPUTERNAME%_result.txt
ECHO [+]W13 end                           
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W14 start            
ECHO �� W-14 : IIS ���ʿ��� ���� ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ش� �� ����Ʈ�� IISSamples, IISHelp ���� ���͸��� �������� ���� ��� ��ȣ >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "MajorVersion" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "MajorVersion" >> chkVersion.txt
for /F "tokens=3 delims= " %%M in (chkVersion.txt) do set value=%%M
set /A getValue=0x%value:~-1%
if %getValue% EQU 10 (
  echo IIS Version 10 not relevant W14. 								>> %COMPUTERNAME%_result.txt
  ECHO �� ��� : ��ȣ               										>> %COMPUTERNAME%_result.txt
  GOTO :END14
)
if %getValue% NEQ 10 (
  ECHO �� ��� : ���� ���� �ʿ�               									>> %COMPUTERNAME%_result.txt
  GOTO :END14
)
:END14
set "value="
set "getValue="
del chkVersion.txt
ECHO [+]W14 end                           
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

REM computer management���� nobody ���� �߰�
REM secpol.msc -> Local Policies -> User Rights Assignment -> Allow log on locally���� nobody �׷� �߰�
ECHO [+]W15 start            
ECHO �� W-15 : �� ���μ��� ���� ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �� ���μ����� �� ���� ��� �ʿ��� �ּ��� �������� �����Ǿ� �ִ� ��� ��ȣ 		>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
set chkNobodyGroup=0
net localgroup | findstr /i "nobodys" > nul
net localgroup | findstr /i "nobodys" 									>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 set chkNobodyGroup=1
net user | findstr /i "nobody" > nul
net user | findstr /i "nobody" 											>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 set chkNobodyGroup=1
IF %chkNobodyGroup%==0 (
  GOTO BAD15
)
IF %chkNobodyGroup%==1 (
  reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "PathWWWRoot" >> %COMPUTERNAME%_result.txt
  reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "PathWWWRoot" > getRoot.txt
  FOR /F "eol=  tokens=3 delims= " %%L IN (getRoot.txt) DO set value=%%L
)  
set rootPath=C:%value:~13%
icacls "%rootPath%" 													>> %COMPUTERNAME%_result.txt
icacls "%rootPath%" > chkPermission.txt
type chkPermission.txt | findstr /i "nobody" > nul
IF ERRORLEVEL 1 GOTO BAD15
type chkPermission.txt | findstr /i "nobody" > chkPermissionDetails.txt
type chkPermissionDetails.txt | findstr "(F)" > nul
IF ERRORLEVEL 1 GOTO BAD15
GOTO GOOD15
:BAD15
ECHO Not set 'nobody' user or 'nobodys' group. 							>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
GOTO END15
:GOOD15
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
:END15
if exist chkPermissionDetails.txt del chkPermissionDetails.txt
if exist chkPermission.txt del chkPermission.txt
if exist getRoot.txt del getRoot.txt
set "value="
set "chkNobodyGroup="
set "rootPath="
ECHO [+]W15 end                           
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W16 start            
ECHO �� W-16 : IIS ��ũ ������                								>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ɺ��� ��ũ, aliases, �ٷΰ��� ���� ����� ������� �ʴ� ��� ��ȣ 			>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "PathWWWRoot" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "PathWWWRoot" > getRoot.txt
FOR /F "eol=  tokens=3 delims= " %%L IN (getRoot.txt) DO set value=%%L
set rootPath=C:%value:~13%
dir %rootPath% >> %COMPUTERNAME%_result.txt
dir %rootPath% | findstr ".lnk" > nul
IF ERRORLEVEL 1 GOTO GOOD16
IF NOT ERRORLEVEL 1 GOTO BAD16
:BAD16
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
GOTO END16
:GOOD16
ECHO Not exist link file in root folder. 								>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
:END16
if exist getRoot.txt del getRoot.txt
set "value="
set "rootPath="
ECHO [+]W16 end                           
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W17 start            
ECHO �� W-17 : IIS ���� ���ε� �� �ٿ�ε� ����                					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �� ���μ����� ���� �ڿ� ������ ���� ���ε� �� �ٿ�ε� �뷮�� �����ϴ� ��� ��ȣ 	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "PathWWWRoot" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "PathWWWRoot" > getRoot.txt
FOR /F "eol=  tokens=3 delims= " %%L IN (getRoot.txt) DO set value=%%L
set rootPath=C:%value:~13%
ECHO \Check %rootPath%\web.config Configuration.\ 						>> %COMPUTERNAME%_result.txt
IF NOT Exist %rootPath%\web.config GOTO BAD17
type %rootPath%\web.config | findstr "maxAllowedContentLength" 			>> %COMPUTERNAME%_result.txt
type %rootPath%\web.config | findstr "maxAllowedContentLength" > nul
IF ERRORLEVEL 1 GOTO BAD17
ECHO. >> %COMPUTERNAME%_result.txt
ECHO \Check ApplicationHost.config Configuration.\ 						>> %COMPUTERNAME%_result.txt
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr "maxRequestEntityAllowed" >> %COMPUTERNAME%_result.txt
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr "maxRequestEntityAllowed" > nul
IF ERRORLEVEL 1 GOTO BAD17
GOTO GOOD17
:BAD17
ECHO Not set configuration or Not exist configuration file. 			>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
GOTO END17
:GOOD17
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
:END17
if exist getRoot.txt del getRoot.txt
set "value="
set "rootPath="
ECHO [+]W17 end                           
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

REM Servermanager -> Handler Mappings & Request Filtering
ECHO [+]W18 start            
ECHO �� W-18 : IIS DB ���� ����� ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : .asa ���� �� Ư�� ���۸� �����ϵ��� �����Ͽ� ������ ��� �Ǵ� ������ ���� ��� ��ȣ >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt

ECHO \Check handler mapping\ 											>> %COMPUTERNAME%_result.txt
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr "modules" >> %COMPUTERNAME%_result.txt
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr "modules" > chkMapping.txt
type chkMapping.txt | findstr ".asa" > nul
IF NOT ERRORLEVEL 1 GOTO BAD18
ECHO. >> %COMPUTERNAME%_result.txt
ECHO \Check request filtering\ 											>> %COMPUTERNAME%_result.txt
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr ".asa" >> %COMPUTERNAME%_result.txt
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr ".asa" > chkFiltering.txt
type chkFiltering.txt | findstr "false" > nul
IF ERRORLEVEL 1 GOTO BAD18
GOTO GOOD18
:BAD18
ECHO Not set configuration. 											>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
GOTO END18
:GOOD18
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
:END18
ECHO Need to checking for each website 'web.config' files. 				>> %COMPUTERNAME%_result.txt
if exist chkMapping.txt del chkMapping.txt
if exist chkFiltering.txt del chkFiltering.txt
ECHO [+]W18 end                           
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W19 start            
ECHO �� W-19 : IIS ���� ���丮 ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ش� �� ����Ʈ�� IIS Admin, IIS Adminpwd ���� ���͸��� �������� �ʴ� ��� ��ȣ >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "MajorVersion" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "MajorVersion" >> chkVersion.txt
for /F "tokens=3 delims= " %%M in (chkVersion.txt) do set value=%%M
set /A getValue=0x%value:~-1%
if %getValue% EQU 10 (
  echo IIS Version 10 not relevant W19. 								>> %COMPUTERNAME%_result.txt
  ECHO �� ��� : ��ȣ               										>> %COMPUTERNAME%_result.txt
  GOTO :END19
)
if %getValue% NEQ 10 (
  ECHO �� ��� : ���� ���� �ʿ�              		 							>> %COMPUTERNAME%_result.txt
  GOTO :END19
)
:END19
set "value="
set "getValue="
del chkVersion.txt
ECHO [+]W19 end                           
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W20 start            
ECHO �� W-20 : IIS ������ ���� ACL ����               							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Ȩ ���丮 ���� �ִ� ���� ���ϵ鿡 ���� Everyone ������ �������� �ʴ� ��� ��ȣ  >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO IIS Manager --/ Web Sites --/ Basic Settings --/ check "Physical Path"         >> %COMPUTERNAME%_result.txt
ECHO Enter 'Web Site Root Folder' --/ check 'Everyone permission on Subfiles(.asp, CGI)' >> %COMPUTERNAME%_result.txt
ECHO \Web Site Root Folder\            									>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "PathWWWRoot" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "PathWWWRoot" > getRoot.txt
FOR /F "eol=  tokens=3 delims= " %%L IN (getRoot.txt) DO set value=%%L
set rootPath=C:%value:~13%
ECHO \Sub file(CGI, Script) List \ 										>> %COMPUTERNAME%_result.txt

rem rootpath=c:\inetpub\wwwroot
dir "%rootPath%" | findstr /i /l ".exe .dll .cmd .pl .asp" > chkSubFileList.txt
setlocal enabledelayedexpansion
FOR /F "eol=  tokens=5 delims= " %%L IN (chkSubFileList.txt) DO (
  set getFileNamePrefix=%%L
  set getFileName=%rootPath%\!getFileNamePrefix!
  icacls "!getFileName!"                                  				>> %COMPUTERNAME%_result.txt
  icacls "!getFileName!" | findstr "Everyone" > nul
  IF NOT ERRORLEVEL 1 ECHO Exist 'Everyone' permission this file. 		>> %COMPUTERNAME%_result.txt
)

dir "%rootPath%" | findstr /i /l "<DIR>" > chkSubFolderList.txt
FOR /F "skip=2 eol=  tokens=5 delims= " %%L IN (chkSubFolderList.txt) DO (
  set folderPath=%rootPath%\%%L
  dir "!folderPath!" | findstr /i /l ".exe .dll .cmd .pl .asp" > chkSubFileList.txt
  setlocal enabledelayedexpansion
  FOR /F "eol=  tokens=5 delims= " %%L IN (chkSubFileList.txt) DO (
    set getFileName=%%L
    set getFilePath=!folderPath!\!getFileName!
    icacls "!getFilePath!"                                 				>> %COMPUTERNAME%_result.txt
    icacls "!getFilePath!" | findstr "Everyone" > nul
    IF NOT ERRORLEVEL 1 ECHO Exist 'Everyone' permission this file. 	>> %COMPUTERNAME%_result.txt
  )
) 

:END20
ECHO �� ��� : ���� ���� �ʿ�               									>> %COMPUTERNAME%_result.txt
ECHO [+]W20 end
del getRoot.txt
del chkSubFileList.txt
del chkSubFolderList.txt
set "value="
set "rootPath="
set "folderPath="
set "getFileName="
set "getFileNamePrefix="
set "getFilePath="

ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W21 start            
ECHO �� W-21 : IIS �̻�� ��ũ��Ʈ ���� ����               						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ����� ����(.htr .idc .stm .shtm .shtml .printer .htw .ida. idq)�� �������� �ʴ� ��� ��ȣ >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO IIS Manager --/ Web Sites --/ Handler Mapping --/ check extension         >> %COMPUTERNAME%_result.txt
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr /i /l ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" > nul
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr /i /l ".htr .idc .stm .shtm .shtml .printer .htw .ida .idq" >> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 GOTO GOOD21
IF NOT ERRORLEVEL 1 GOTO BAD21
:BAD21
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
GOTO END21
:GOOD21
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
:END21
ECHO [+]W21 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W22 start            
ECHO �� W-22 : IIS Exec ��ɾ� �� ȣ�� ����               						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : IIS 5.0 �������� �ش� ������Ʈ�� ���� 0�̰ų�, IIS 6.0 ���� �̻��� ��� 		>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO Regedit --\ HKLM\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters --\ check 'SSIEnableCmdDirective=0'         >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "MajorVersion" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" | findstr "MajorVersion" >> chkVersion.txt
for /F "tokens=3 delims= " %%M in (chkVersion.txt) do set value=%%M
set /A getValue=0x%value:~-1%
if %getValue% EQU 10 (
  echo IIS Version 10 not relevant W22. 								>> %COMPUTERNAME%_result.txt
  ECHO �� ��� : ��ȣ               										>> %COMPUTERNAME%_result.txt
  GOTO :END22
)
if %getValue% NEQ 10 (
  ECHO �� ��� : ���� ���� �ʿ�               								>> %COMPUTERNAME%_result.txt
  GOTO :END22
)
:END22
del chkVersion.txt
set "value="
set "getValue="
ECHO [+]W22 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W23 start            
ECHO �� W-23 : IIS WebDav ��Ȱ��ȭ               							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : WebDav�� ��Ȱ��ȭ �Ǿ� �ִ� ��� ��� 								>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO IIS Manager --/ Web Sites --/ ISAPI and CGI Restriction --/ check WebDav Restriction='not allowed'         >> %COMPUTERNAME%_result.txt
ECHO \Current Configuration\            								>> %COMPUTERNAME%_result.txt
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr /i /l "webdav.dll" | findstr /i /l "true" >> %COMPUTERNAME%_result.txt
type c:\windows\system32\inetsrv\config\applicationHost.config | findstr /i /l "webdav.dll" | findstr /i /l "true" > nul
IF ERRORLEVEL 1 GOTO GOOD23
IF NOT ERRORLEVEL 1 GOTO BAD23
:BAD23
ECHO �� ��� : ���            												>> %COMPUTERNAME%_result.txt
GOTO END23
:GOOD23
ECHO WebDav was not allowed or not existed.         					>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ��ȣ         												>> %COMPUTERNAME%_result.txt
:END23
ECHO [+]W23 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

SET /A IISIsSet=1
GOTO IISExist

:IISNotExist
ECHO IIS Server is not exist. Skip W11-W23 								>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                		 							>> %COMPUTERNAME%_result.txt
SET /A IISIsSet=0
:IISExist

ECHO [+]W24 start
ECHO �� W-24 : NetBIOS ���ε� ���� ���� ����                					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : TCP/IP�� NetBIOS ���� ���ε��� ���� �Ǿ� �ִ� ��� ��ȣ      			>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\ /s > netbios.txt
TYPE netbios.txt 														>> %COMPUTERNAME%_result.txt
TYPE netbios.txt | find /i "NetbiosOPtions" > netbios2.txt
TYPE netbios.txt | find /i "0x0" > nul
IF ERRORLEVEL 0 ECHO �� ��� : ��ȣ 										>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 0 ECHO �� ��� : ��� 									>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W24 end
DEL netbios.txt
DEL netbios2.txt

ECHO [+]W25 start
ECHO �� W-25 : FTP ���� ���� ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : FTP ���񽺸� ������� �ʰų� secure FTP ���񽺸� ���� ��ȣ      		>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services"		> nul
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services" | find "MSFTPSVC" > ftp.txt
ECHO �� ��� : ���� ���� �ʿ� 												>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W25 end
DEL ftp.txt

ECHO [+]W26 start
ECHO �� W-26 : FTP ���丮 ���ٱ��� ����                						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : FTP Ȩ ���丮�� Everyone ������ ���� ���      					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ� 												>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W26 end

ECHO [+]W27 start
ECHO �� W-27 : Anonymous FTP ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : FTP ���񽺸� ������� �ʰų�, "�͸� ���� ���"�� üũ���� ���� ��� ��ȣ    >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ� 												>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W27 end

ECHO [+]W28 start
ECHO �� W-28 : FTP ���� ���� ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Ư�� IP �ּҿ����� FTP ������ �����ϵ��� �������� ������ ������ ��� ��ȣ   	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ� 												>> %COMPUTERNAME%_result.txt
ECHO.                                         					 		>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W28 end

ECHO [+]W29 start
ECHO �� W-29 : DNS Zone Transfer ����                						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : DNS ���� ������� �ʰ� ���� ���� ����� ������� ������ Ư�� �����θ� ������ �Ǵ� ��� ��ȣ  >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
SC query "DNS" > chkDNS.txt
IF ERRORLEVEL 1 (
  ECHO Not found DNS Service 											>> %COMPUTERNAME%_result.txt
  ECHO �� ��� : ��ȣ 														>> %COMPUTERNAME%_result.txt
  GOTO END42
)
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" > chkDNSZone.txt
REM check zone auto update
for /f "tokens=* delims=" %%i in (chkDNSZone.txt) do (
  reg query "%%i" | findstr "AllowUpdate" 								>> chkAllowUpdate.txt
  reg query "%%i" 														>> %COMPUTERNAME%_result.txt
)
type chkAllowUpdate.txt | findstr "0x1" > nul
IF NOT ERRORLEVEL 1 echo �� ��� : ��� 									>> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 echo �� ��� : ��ȣ 										>> %COMPUTERNAME%_result.txt
:END42 
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W29 end															>> %COMPUTERNAME%_result.txt
del chkDNS.txt
IF Exist chkDNSZone.txt del chkDNSZone.txt
IF Exist chkAllowUpdate.txt del chkAllowUpdate.txt

ECHO [+]W30 start
ECHO �� W-30 : RDS(Remote Data Services)����              				>> %COMPUTERNAME%_result.txt
ECHO �� ����      														>> %COMPUTERNAME%_result.txt
ECHO   1.IIS�� ������� ���� ���               								>> %COMPUTERNAME%_result.txt
ECHO   2. Windows 2000 ������ 4, Windows 2003 ������ 2 �̻� ��ġ�Ǿ� �ִ� ��� >> %COMPUTERNAME%_result.txt
ECHO   3. ����Ʈ �� ����Ʈ�� MSADC ���� ���丮�� �������� ���� ���               	>> %COMPUTERNAME%_result.txt
ECHO   4. �ش� ������Ʈ�� ���� �������� �ʴ� ���               					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurePipeServers\winreg" | findstr "Description" >> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 ECHO winreg�� �������� �ʽ��ϴ�.(�����Ͽ� �������� ���) 			>> %COMPUTERNAME%_result.txt
echo �� ��� : ���� ���� �ʿ�													>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W30 end

ECHO [+]W31 start
ECHO �� W-31 : �ֽ� ������ ����               								>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ֽ� �������� ��ġ�Ǿ� ������ ���� ���� �� ����� ������ ��� ��ȣ     	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
ECHO ����� ���ͺ�(winver ��ɾ� ���� Ȯ�ΰ���)  								>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ� 													>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W31 end															

ECHO [+]W32 start
ECHO �� W-32 : �ֽ� HOT FIX ����               								>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ֽ� HotFix�� �ִ��� �ֱ������� ����͸��ϰ� �ݿ��ϰų�, PMS Agent�� ��ġ�Ǿ� �ڵ���ġ ������ ����� ��� ��ȣ >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ�													>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W32 end

ECHO [+]W33 start
ECHO �� W-33 : ��� ���α׷� ������Ʈ               							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ���̷��� ��� ���α׷��� �ֽ� ���� ������Ʈ�� ��ġ�Ǿ� �ְų�, �� �ݸ�ȯ���� ��� ��� ������Ʈ�� ���� ���� �� ���� ����� ������ ��� ��ȣ >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ�													>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W33 end															>> %COMPUTERNAME%_result.txt

ECHO [+]W34 start
ECHO �� W-34 : �α��� ������ ���� �� ����               						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ���ӱ�� ���� ���� �α�, ���� ���α׷� �� �ý��� �α� ��Ͽ� ���� ���������� ����, �м�, ����Ʈ �ۼ� �� ���� ���� ��ġ�� �̷������ ��� ��ȣ     >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ																>> %COMPUTERNAME%_result.txt
ECHO "AuditLogonEvents" = 3 ����											>> %COMPUTERNAME%_result.txt
ECHO "AuditObjectAccess" = 3 ����										>> %COMPUTERNAME%_result.txt
ECHO "AuditPrivilegeUse" = 3 ����										>> %COMPUTERNAME%_result.txt
ECHO "AuditAccountManage" = 3 ����										>> %COMPUTERNAME%_result.txt
ECHO "AuditAccountLogon" = 3 ����										>> %COMPUTERNAME%_result.txt
type securityPolicy.txt | findstr "Audit"            					>> %COMPUTERNAME%_result.txt
type securityPolicy.txt | findstr "AuditLogonEvents" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "3"
IF ERRORLEVEL 1 GOTO BAD57
type securityPolicy.txt | findstr "AuditObjectAccess" >> chkAuditSetting.txt
type chkAuditSetting.txt | findstr "3"
IF ERRORLEVEL 1 GOTO BAD57
type securityPolicy.txt | findstr "AuditPrivilegeUse" >> chkAuditSetting.txt
type chkAuditSetting.txt | findstr "3"
IF ERRORLEVEL 1 GOTO BAD57
type securityPolicy.txt | findstr "AuditAccountManage" >> chkAuditSetting.txt
type chkAuditSetting.txt | findstr "3"
IF ERRORLEVEL 1 GOTO BAD57
type securityPolicy.txt | findstr "AuditAccountLogon" >> chkAuditSetting.txt
type chkAuditSetting.txt | findstr "3"
IF ERRORLEVEL 1 GOTO BAD57
IF NOT ERRORLEVEL 1 GOTO GOOD57
:BAD57
ECHO �� ��� : ���ͺ� �ʿ�                     									>> %COMPUTERNAME%_result.txt
GOTO END57
:GOOD57
ECHO �� ��� : ���ͺ� �ʿ�                     									>> %COMPUTERNAME%_result.txt
:END57
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------             				>> %COMPUTERNAME%_result.txt
ECHO.                                          							>> %COMPUTERNAME%_result.txt
ECHO [+]W34 end			
DEL chkAuditSetting.txt

ECHO [+]W35 start
ECHO �� W-35 : �������� �׼��� �� �� �ִ� ������Ʈ�� ���	 						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Remote Registry ���񽺰� ������� ������ ��ȣ						>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
sc query RemoteRegistry 												>> %COMPUTERNAME%_result.txt
sc query RemoteRegistry | findstr /i "RUNNING"
IF ERRORLEVEL 1 ECHO �� ��� : ��ȣ  										>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 ECHO �� ��� : ���  									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W35 end

ECHO [+]W36 start
ECHO �� W-36 : ��� ���α׷� ��ġ	 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ��� ���α׷��� ��ġ�Ǿ� �ִ� ��� ��ȣ								>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ�				  									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W35 end

ECHO [+]W37 start
ECHO �� W-37 : SAM ���� ���� ���� ����	 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : SAM ���� ���ٱ��ѿ� Administrator, System �׷츸 �����Ǿ� ������ ��ȣ			>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																		>> %COMPUTERNAME%_result.txt
icacls %windir%\system32\config\SAM	> checkPermissions.txt						>> %COMPUTERNAME%_result.txt
icacls %windir%\system32\config\SAM	> checkPermissions.txt
TYPE checkPermissions.txt | findstr /V /C:"SYSTEM:" | findstr /V /C:"Administrators" | findstr /V /C:"Successfully" > checkPermissions.txt
TYPE checkPermissions.txt | findstr /C:":" > nul
IF ERRORLEVEL 1 GOTO GOOD37
IF NOT ERRORLEVEL 1 GOTO BAD37

:GOOD37	
ECHO �� ��� : ��ȣ				  											>> %COMPUTERNAME%_result.txt
GOTO END37
:BAD37
ECHO �� ��� : ���					  										>> %COMPUTERNAME%_result.txt
:END37
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
DEL CheckPermissions.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W37 end

ECHO [+]W38 start
ECHO �� W-38 : ȭ�� ��ȣ�� ����	 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ȭ�麸ȣ�� ��� �� �ٽ� ������ �� �α׿� ȭ�� ǥ�� üũ					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | find "Screen"		>> %COMPUTERNAME%_result.txt
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | find "ScreenSaveActive" | find "1" > NUL 
IF ERRORLEVEL 1 (
	ECHO Not set ScreenSaveActive										>> %COMPUTERNAME%_result.txt
	GOTO BAD38
)
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" | find "ScreenSaverIsSecure" | find "1" > NUL 
IF ERRORLEVEL 1 (
	ECHO Not set ScreenSaverIsSecure									>> %COMPUTERNAME%_result.txt
	GOTO BAD38
)
:GOOD38	
ECHO �� ��� : ��ȣ				  											>> %COMPUTERNAME%_result.txt
GOTO END38
:BAD38
ECHO �� ��� : ���					  										>> %COMPUTERNAME%_result.txt
:END38
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W38 end

ECHO [+]W39 start
ECHO �� W-39 : �α׿� ���� �ʰ� �ý��� ���� ��� ����	 							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �α׿� ���� �ʰ� �ý��� ���� ����� '������'�� ��� ��ȣ 				>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | find "shutdownwithoutlogon" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | find "shutdownwithoutlogon" | find "1" > nul
IF ERRORLEVEL 1 GOTO BAD39
:GOOD39	
ECHO �� ��� : ��ȣ				  											>> %COMPUTERNAME%_result.txt
GOTO END39
:BAD39
ECHO �� ��� : ���					  										>> %COMPUTERNAME%_result.txt
:END39
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W39 end

ECHO [+]W40 start
ECHO �� W-40 : ���� �ý��ۿ��� ������ �ý��� ����	 								>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "���� �ý��ۿ��� ������ �ý��� ����" ��å�� 'Administrators'�� �����ϴ� ��� ��ȣ				>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
type securityPolicy.txt | findstr "SeRemoteShutdownPrivilege"		>> %COMPUTERNAME%_result.txt
type securityPolicy.txt | findstr "SeRemoteShutdownPrivilege" 		> rshutdownAccount.txt
FOR /f "tokens=2 delims='='" %%L in (rshutdownAccount.txt) do set vuln=%%L
IF NOT "%vuln%"==" *S-1-5-32-544" (
	GOTO BAD
)
:GOOD40	
ECHO �� ��� : ��ȣ				  											>> %COMPUTERNAME%_result.txt
GOTO END40
:BAD40
ECHO �� ��� : ���					  										>> %COMPUTERNAME%_result.txt
:END40
DEL rshutdownAccount.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W40 end

ECHO [+]W41 start
ECHO �� W-41 : ���� ���縦 �α��� �� ���� ��� ��� �ý��� ���� 	 					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ش� ��å�� ��Ȱ��ȭ �Ǿ� �ִ� ��� ��ȣ								>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | findstr "crashonauditfail" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | findstr "crashonauditfail" | findstr "0x0" > nul
IF ERRORLEVEL 1 GOTO BAD41
:GOOD41
ECHO �� ��� : ��ȣ				  											>> %COMPUTERNAME%_result.txt
GOTO END41
:BAD41
ECHO �� ��� : ���					  										>> %COMPUTERNAME%_result.txt
:END41
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W41 end

ECHO [+]W42 start
ECHO �� W-42 : SAM ������ ������ �͸� ���� ��� ����	 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "SAM ������ ������ �͸� ���� ��� ����" ��å�� �����Ǿ� �ִ� ��� ��ȣ 		>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO SECPOL.MSC --/ Local Policies --/ Security Options	--/   			    >> %COMPUTERNAME%_result.txt
ECHO 'Network access:Do not allow anonymous enumeration of SAM accounts and shares' Set 'Disabled'  >> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ�				  									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W42 end

ECHO [+]W43 start
ECHO �� W-43 : Autologin ��� ����	 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : AutoAdminLogon ���� ���ų� 0���� �����Ǿ� �ִ� ��� ��ȣ 					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | findstr "AutoAdminLogon" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" | findstr "1" > nul
IF ERRORLEVEL 1 GOTO BAD43
:GOOD43
ECHO �� ��� : ��ȣ				  											>> %COMPUTERNAME%_result.txt
GOTO END43
:BAD43
ECHO �� ��� : ���					  										>> %COMPUTERNAME%_result.txt
:END43
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W43 end

ECHO [+]W44 start
ECHO �� W-44 : �̵��� �̵�� ���� �� ������ ���	 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "�̵��� �̵�� ���� �� ������ ���" ��å�� "Administrator"�� �Ǿ� �ִ� ��� ��ȣ					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO SECPOL.MSC --/ Local Policies --/ Security Options	--/   			    >> %COMPUTERNAME%_result.txt
ECHO 'Devices: Allowed to format and eject removable media' Set 'Administrator'  >> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ�				  									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W44 end

ECHO [+]W45 start
ECHO �� W-45 : ��ũ���� ��ȣȭ ����	 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "������ ��ȣ�� ���� ������ ��ȣȭ" ��å�� ���õ� ��� ��ȣ 					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO Select Folder --/ Folder Properties --/ General --/   			    >> %COMPUTERNAME%_result.txt
ECHO Advanced --/ Compress or Encrypt attributes --/	  			    >> %COMPUTERNAME%_result.txt
ECHO Check 'Encrypt contents to secure data'			  			    >> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ�				  									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W45 end

ECHO [+]W46 start
ECHO �� W-46 : Everyone ��� ������ �͸� ����ڿ��� ���� ���� 						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "Everyone ��� ������ �͸� ����ڿ��� ����" ��å�� "��� �� ��" ���� �Ǿ� �ִ� ��� ��ȣ			>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find /i "EvryoneIncludesAnomymous"    		>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find /i "EvryoneIncludesAnomymous" | find "4,0" > NUL
IF ERRORLEVEL 1 ECHO �� ��� : ���  										>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 ECHO �� ��� : ��ȣ  									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W46 end

ECHO [+]W47 start
ECHO �� W-47 : ���� ��� �Ⱓ ���� 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "���� ��� �Ⱓ" �� "���� ��� �Ⱓ ������� ���� �Ⱓ"�� �����Ǿ� �ִ� ��� ��ȣ(60�� �̻��� ������ �����ϱ⸦ �ǰ���)		>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
net accounts | findstr /I /C:"Lockout duration (minutes)"                 		>> %COMPUTERNAME%_result.txt
net accounts | findstr /I /C:"Lockout observation window (minutes)"               >> %COMPUTERNAME%_result.txt
net accounts | findstr /I /C:"Lockout duration (minutes)"  >> 47-Ltime.txt
for /f "tokens=1-6" %%a IN (47-Ltime.txt) DO SET Ltime=%%d
net accounts | findstr /I /C:"Lockout observation window (minutes)"  >> 47-window.txt
for /f "tokens=1-6" %%a IN (47-window.txt) DO SET window=%%d
if %Ltime% GEQ 60 IF %window% GEQ 60 GOTO 47-Y
:47-Y
ECHO �� ��� : ��ȣ  														>> %COMPUTERNAME%_result.txt
GOTO 47-END
:47-N
ECHO �� ��� : ���  														>> %COMPUTERNAME%_result.txt
GOTO 47-END
:47-END
del 47-Ltime.txt
del 47-window.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W47 end

ECHO [+]W48 start
ECHO �� W-48 : �н����� ���⼺ ���� 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "��ȣ�� ���⼺�� �����ؾ� ��" ��å�� "���"���� �Ǿ� �ִ� ��� ��ȣ				>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find /i "PasswordComplexity"   				>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find /i "PasswordComplexity" | find "1" > NUL
IF ERRORLEVEL 1 ECHO �� ��� : ���  										>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 ECHO �� ��� : ��ȣ  									>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W48 end

ECHO [+]W49 start
ECHO �� W-49 : �н����� �ּ� ��ȣ ���� 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ּ� ��ȣ ���̰� 8���� �̻����� �����Ǿ� �ִ� ��� ��ȣ						>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find /i "MinimumPasswordLength"    			>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find "MinimumPasswordLength =" > file.txt
FOR /f "tokens=1-3" %%a IN (file.txt) DO SET passwd_length=%%c
IF %passwd_length% GEQ 8 ECHO �� ��� : ��ȣ  								>> %COMPUTERNAME%_result.txt
IF NOT %passwd_length% GEQ 8 ECHO �� ��� : ��� 							>> %COMPUTERNAME%_result.txt
DEL file.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W49 end

ECHO [+]W50 start
ECHO �� W-50 : �н����� �ִ� ��� �Ⱓ 											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ִ� ��ȣ ��� �Ⱓ�� 90�� ���Ϸ� �����Ǿ� �ִ� ��� "��ȣ"					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find /i "MaximumPasswordAge" | find /v "\"	>> %COMPUTERNAME%_result.txt
ECHO. 																	>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find "MaximumPasswordAge =" > file.txt
FOR /f "tokens=1-3" %%a IN (file.txt) DO SET passwd_maxage=%%c
IF %passwd_maxage% LEQ 90 ECHO �� ��� : ��ȣ								>> %COMPUTERNAME%_result.txt
IF NOT %passwd_maxage% LEQ 90 ECHO �� ��� : ���							>> %COMPUTERNAME%_result.txt
DEL file.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W50 end

ECHO [+]W51 start
ECHO �� W-51 : �н����� �ּ� ��� �Ⱓ											>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ּ� ��ȣ ��� �Ⱓ�� 0���� ū ������ �����Ǿ� �ִ°�� "��ȣ" 				>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ 																>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find /i "MinimumPasswordAge"					>> %COMPUTERNAME%_result.txt
ECHO. 																	>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | find "MinimumPasswordAge =" > file.txt
FOR /f "tokens=1-3" %%a IN (file.txt) DO SET passwd_minage=%%c
IF %passwd_minage% GEQ 1 ECHO �� ��� : ��ȣ								>> %COMPUTERNAME%_result.txt
IF NOT %passwd_minage% GEQ 1 ECHO �� ��� : ���							>> %COMPUTERNAME%_result.txt
DEL file.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W51 end

ECHO [+]W52 start
ECHO �� W-52 : ������ ����� �̸� ǥ�� ����										>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ������ ����� �̸� ǥ�� ������ ������� �����Ǿ� �ִ� ��� "��ȣ"				>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ								 								>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
REG query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | findstr /I "DontDisplayLastUserName" >> %COMPUTERNAME%_result.txt
REG query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | findstr /I "DontDisplayLastUserName" | find "1" > NUL
IF ERRORLEVEL 1 ECHO �� ��� : ��ȣ											>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 ECHO �� ��� : ���										>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO ---------------------------------------- 							>> %COMPUTERNAME%_result.txt
ECHO.																	>> %COMPUTERNAME%_result.txt
ECHO [+]W52 end

REM [ChkPath]secpol.msc -> Local Policies -> User Rights Assignment -> Allow log on locally
REM [ValuePath] secedit -> SeInteractiveLogonRight value
ECHO [+]W53 start
ECHO �� W-53 : ���� �α׿� ���               									>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ���� �α׿� ��� ��å�� Administrators, IUSR_�� �����ϴ� ��� ��ȣ 		>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | findstr "SeInteractiveLogonRight" > chkConf.txt
FOR /F "eol=  tokens=3 delims= " %%L IN (chkConf.txt) DO SET getIDs=%%L
ECHO *** Allow local logon accounts List *** 							>> %COMPUTERNAME%_result.txt
SET /A condition=0
CALL :PARSE53  "%getIDs%"
GOTO RESULT53
REM Start Loop
:PARSE53
SET list=%~1
FOR /F "tokens=1* delims=," %%A IN ("%list%") do (
  ECHO %%A >> %COMPUTERNAME%_result.txt
  IF NOT "%%A"=="*S-1-5-32-544" (
    IF NOT "%%A"=="*S-1-5-17" (
	  SET /A condition=1
	)
  )
  IF NOT "%%B"=="" CALL :PARSE53 "%%B"
)
TIMEOUT 2 > nul
GOTO EOF
REM End Loop
:RESULT53
IF %condition% NEQ 0 GOTO BAD53
GOTO GOOD53
:BAD53
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
GOTO END53
:GOOD53
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
:END53
DEL chkConf.txt
SET "getIDs="
SET "condition="
SET "list="
ECHO [+]W53 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

REM [ChkPath]secpol.msc -> local policy -> security options -> Network access: Allow anonymous SID/Name translation
REM [ValuePath] secedit -> LSAAnonymousNameLookup value
ECHO [+]W54 start
ECHO �� W-54 : �͸� SID/�̸� ��ȯ ��� ����              						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "�͸� SID/�̸� ��ȯ ���" ��å�� "��� �� ��"���� �Ǿ� �ִ� ��� 			>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                  												>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | findstr /L "LSAAnonymousNameLookup"			>> %COMPUTERNAME%_result.txt
TYPE securityPolicy.txt | findstr /L "LSAAnonymousNameLookup" 	> chkConf.txt
FOR /F "eol=  tokens=3 delims= " %%L IN (chkConf.txt) DO SET /A value=%%L
IF %value% NEQ 0 GOTO BAD54
GOTO GOOD54 
:BAD54
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
GOTO END54
:GOOD54
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
:END54
DEL chkConf.txt
SET "value="
ECHO [+]W54 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W55 start
ECHO �� W-55 : �ֱ� ��ȣ ��� ��å ���� ���� ����               					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ֱ� ��ȣ ����� 4�� �̻����� �����Ǿ� �ִ� ��� ��ȣ 						>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
net accounts | findstr /L "history" 									>> %COMPUTERNAME%_result.txt
net accounts | findstr /L "history" > chkConf.txt
FOR /F "eol=  tokens=6 delims= " %%L IN (chkConf.txt) DO SET value=%%L
ECHO value=%value%
IF %value% GEQ 4 GOTO GOOD55
:BAD55
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
GOTO END55
:GOOD55
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
:END55
#DEL chkConf.txt
SET "value="
ECHO [+]W55 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W56 start
ECHO �� W-56 : �ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����               			>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "�ܼ� �α׿� �� ���� �������� �� ��ȣ ��� ����" ��å�� "���"�� ��� ��ȣ 		>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse > chkConf.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse >> %COMPUTERNAME%_result.txt
FOR /F "eol=  tokens=3 delims= " %%L IN (chkConf.txt) DO SET value=%%L
SET getValue=%value:~-1%
IF %getValue% EQU 1 GOTO GOOD56
GOTO BAD56
:GOOD56
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
GOTO END56
:BAD56
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
:END56
DEL chkConf.txt
SET "value="
SET "getValue="
ECHO [+]W56 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt


ECHO [+]W57 start
ECHO �� W-57 : �����͹̳� ���� ������ ����� �׷� ����               					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : (������ ������ ����) ���� ������ ������ ������ �����Ͽ� Ÿ ������� ���� ������ �����ϰ�, �������� ����� �׷쿡 ���ʿ��� ������ ��ϵǾ� ���� ���� ��� ��ȣ               >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
ECHO *Remote connection using network autentication level*   			>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication   >> %COMPUTERNAME%_result.txt
NET localgroup Administrators > getUser.txt
ECHO *Administrators Group*   											>> %COMPUTERNAME%_result.txt
FOR /F "skip=6" %%L IN (getUser.txt) DO (
  IF NOT "%%L"=="The" (
    ECHO %%L            												>> %COMPUTERNAME%_result.txt
  )
)
ECHO.                   												>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO Control Panel --\ All Control Panel Items --\ System --\ Remote Settings --\ Select Users --\ Delete unnecessary user >> %COMPUTERNAME%_result.txt
ECHO.                   												>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ�               										>> %COMPUTERNAME%_result.txt
:END57
DEL getUser.txt
ECHO [+]W57 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W58 start
ECHO �� W-58 : IIS �͹̳� ���� ��ȣȭ ���� ����                					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �͹̳� ���񽺸� ������� �ʰų� ��� �� ��ȣȭ ������ "Ŭ���̾�Ʈ�� ȣȯ ����(�߰�)" �̻����� ������ ��� ��ȣ                >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" | findstr /l "fDenyTSConnections" > chkConf.txt
FOR /F "eol=  tokens=3 delims= " %%L IN (chkConf.txt) DO SET value=%%L
set /A getValue=%value:~-1%
IF %getValue% EQU 1 GOTO GOOD58_1

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v MinEncryptionLevel >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" | findstr /l "MinEncryptionLevel" > chkConf.txt
FOR /F "eol=  tokens=3 delims= " %%L IN (chkConf.txt) DO SET value=%%L
set /A getValue=%value:~-1%
IF %getValue% LSS 2 GOTO BAD58

GOTO GOOD58_2
:GOOD58_1
ECHO Not used Terminal Service. 										>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
GOTO END58
:GOOD58_2
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
GOTO END58
:BAD58
ECHO Used Terminal Service.      										>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���               											>> %COMPUTERNAME%_result.txt
:END58
del chkConf.txt
set "value="
set "getValue="
ECHO [+]W58 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W59 start
ECHO �� W-59 : IIS ������ ���� ����                							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �� ���� ���� �������� ������ �����Ǿ� �ִ� ��� ��ȣ         			  	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                   											>> %COMPUTERNAME%_result.txt
IF %IISIsSet%==0 GOTO NA59
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO IIS Manager --/ Web Sites --/ Directory Browsing --/ check "Disable" >> %COMPUTERNAME%_result.txt
GOTO NEED59
:NA59
ECHO �� ��� : NA               											>> %COMPUTERNAME%_result.txt
GOTO END59
:NEED59
ECHO �� ��� : ���� ���� �ʿ�               									>> %COMPUTERNAME%_result.txt
:END59
ECHO [+]W59 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W60 start            
ECHO �� W-60 : SNMP ���� ��������                      						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : SNMP ���񽺸� ������� �ʴ� ��� ��ȣ            						>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
SC query "SNMP" > chkSNMP.txt
SC query "SNMP" 														>> %COMPUTERNAME%_result.txt
type chkSNMP.txt | findstr "RUNNING" > nul
IF NOT ERRORLEVEL 1 echo �� ��� : ��� 									>> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 echo �� ��� : ��ȣ 										>> %COMPUTERNAME%_result.txt
ECHO [+]W60 end            
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W61 start            
ECHO �� W-61 : SNMP ���� Ŀ�´�Ƽ��Ʈ���� ���⼺ ����    							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : SNMP ���񽺸� ������� �ʰų� Community String�� public, private�� �ƴ� ��� ��ȣ   >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                              									>> %COMPUTERNAME%_result.txt
REM check snmp service
type chkSNMP.txt | findstr "RUNNING" > nul
IF ERRORLEVEL 1 goto GOOD61-NOTSNMP
REM check snmp community string
:chkpublic
reg query "HKEY_LOCAL_MACHINE\system\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr "public" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\system\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr "public" > nul
IF ERRORLEVEL 1 GOTO chkprivate
IF NOT ERRORLEVEL 1 GOTO BAD61
:chkprivate
reg query "HKEY_LOCAL_MACHINE\system\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr "private" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\system\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities" | findstr "private" > nul
IF NOT ERRORLEVEL 1 GOTO BAD61
:GOOD61
ECHO Not found SNMP Community String in "public, private" 				>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ��ȣ 														>> %COMPUTERNAME%_result.txt
GOTO END61
:GOOD61-NOTSNMP
ECHO Not found SNMP Service 											>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ��ȣ 														>> %COMPUTERNAME%_result.txt
GOTO END61
:BAD61
ECHO �� ��� : ��� 														>> %COMPUTERNAME%_result.txt
:END61
ECHO [+]W61 end            
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W62 start            
ECHO �� W-62 : SNMP Access contorol            							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Ư�� ȣ��Ʈ�κ��� SNMP ��Ŷ �޾Ƶ��̱�� �����Ǿ� �ִ� ��� ��ȣ   			>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
type chkSNMP.txt | findstr "RUNNING" > nul
IF ERRORLEVEL 1 goto GOOD62-NOTSNMP
reg query "HKEY_LOCAL_MACHINE\system\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\system\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers" | findstr "1" > nul
IF NOT ERRORLEVEL 1 (
ECHO �� ��� : ��ȣ 														>> %COMPUTERNAME%_result.txt
GOTO END62		
)
ECHO Accept SNMP packets from any host 									>> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 echo �� ��� : ��� 										>> %COMPUTERNAME%_result.txt
GOTO END62
:GOOD62-NOTSNMP
ECHO Not found SNMP Service 											>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ��ȣ 														>> %COMPUTERNAME%_result.txt
:END62
ECHO [+]W62 end   
del chkSNMP.txt         
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W63 start            
ECHO �� W-63 : DNS ���� ���� ����                     						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : DNS ���񽺸� ������� �ʰų� ���� ������Ʈ "����(�ƴϿ�)"���� �����Ǿ� �ִ� ��� ��ȣ    >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
REM check DNS service
SC query "DNS" > chkDNS.txt
IF ERRORLEVEL 1 (
  ECHO Not found DNS Service 											>> %COMPUTERNAME%_result.txt
  ECHO �� ��� : ��ȣ 														>> %COMPUTERNAME%_result.txt
  GOTO END63
)
REM check DNS auto update
REM get zone name
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones" > chkDNSZone.txt
REM check zone auto update
for /f "tokens=* delims=" %%i in (chkDNSZone.txt) do (
  reg query "%%i" | findstr "AllowUpdate" >> chkAllowUpdate.txt
  reg query "%%i" 														>> %COMPUTERNAME%_result.txt
)
type chkAllowUpdate.txt | findstr "0x1" > nul
IF NOT ERRORLEVEL 1 echo �� ��� : ��� 									>> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 echo �� ��� : ��ȣ 										>> %COMPUTERNAME%_result.txt
:END63
ECHO [+]W63 end            

del chkDNS.txt
IF Exist chkDNSZone.txt del chkDNSZone.txt
IF Exist chkAllowUpdate.txt del chkAllowUpdate.txt
ECHO.                                									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W64 start            
ECHO �� W-64 : HTTP/FTP/SNMP ��� ����                 						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : HTTP, FTP, SMTP ���� �� ��� ������ ������ �ʴ� ��� ��ȣ    			>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                                        						>> %COMPUTERNAME%_result.txt
ECHO \Server Presence or absence\               						>> %COMPUTERNAME%_result.txt
sc query | findstr /i "iis" > nul
IF ERRORLEVEL 1 ECHO IIS Server not exist.          					>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 (
  ECHO IIS Sever exist.                       							>> %COMPUTERNAME%_result.txt
)
sc query | findstr /i "ftp" > nul
IF ERRORLEVEL 1 ECHO FTP Server not exist.          					>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 (
  ECHO FTP Sever exist.                       							>> %COMPUTERNAME%_result.txt
)
sc query | findstr /i "SMTP" > nul
IF ERRORLEVEL 1 ECHO SMTP Server not exist.       						>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 (
  ECHO SMTP Sever exist.                       							>> %COMPUTERNAME%_result.txt
)
ECHO \How to check\                          							>> %COMPUTERNAME%_result.txt
ECHO 1. HTTP                                  							>> %COMPUTERNAME%_result.txt
ECHO 1-1. IIS Manager --\ Web site --\ ISAPI Filter --\ Check "added urlscan.dll"   >> %COMPUTERNAME%_result.txt
ECHO 1-2. C:\Windows\System32\inetserv\urlscan\urlscan.ini    		  	>> %COMPUTERNAME%_result.txt
ECHO --\ RemoteserverHeader=1 and AllowDotInPath=1   					>> %COMPUTERNAME%_result.txt
ECHO 2. FTP                                  							>> %COMPUTERNAME%_result.txt
ECHO IIS Manager --\ FTP Messages --\ Check Banner     					>> %COMPUTERNAME%_result.txt
ECHO 3. SMTP                              								>> %COMPUTERNAME%_result.txt
ECHO IIS 6.0 Manager --\ Check Not Allow 'Metabase Settings'            >> %COMPUTERNAME%_result.txt
echo �� ��� : ���� ���� �ʿ�                        							>> %COMPUTERNAME%_result.txt
:END64
ECHO [+]W64 end
ECHO.                                             						>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------       					>> %COMPUTERNAME%_result.txt
ECHO.                                             						>> %COMPUTERNAME%_result.txt

ECHO [+]W65 start            
ECHO �� W-65 : Telnet ���� ����                								>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Telnet ���񽺰� ���� �Ǿ� ���� �ʰų� ���� ����� NTLM�� ��� ��ȣ          	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
systeminfo | findstr "2016"                  							>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 (
  echo Windows Server 2016 is not suport Telnet Server 					>> %COMPUTERNAME%_result.txt
  echo �� ��� : N/A 														>> %COMPUTERNAME%_result.txt
)
ECHO [+]W65 end            
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W66 start            
ECHO �� W-66 : ���ʿ��� ODBC/OLE-DB ������ �ҽ��� ����̺� ����   					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ý��� DSN �κ��� Data Source�� ���� ����ϰ� �ִ� ��� ��ȣ             	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
ECHO \How to check\            											>> %COMPUTERNAME%_result.txt
ECHO Administrative Tools --\ Related ODBC --\ System DSN --\ Delete Data source if not use.       >> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���� ���� �ʿ�                     								>> %COMPUTERNAME%_result.txt
ECHO [+]W66 end            
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W67 start            
ECHO �� W-67 : �����͹̳� ���� Ÿ�Ӿƿ� ����                      					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �������� �� Timeout ���� ������ ������ ��� ��ȣ      					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
rem gpedit.msc
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" | findstr "MaxIdleTime" > chkTimeout.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" | findstr "MaxIdleTime" >> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 (
  ECHO Not configured Timeout 											>> %COMPUTERNAME%_result.txt
  GOTO BAD67
)
type chkTimeout.txt | findstr "0x0" > nul
IF ERRORLEVEL 1 GOTO GOOD67
IF NOT ERRORLEVEL 1 GOTO BAD67
:BAD67
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
GOTO END67
:GOOD67
ECHO �� ��� : ��ȣ                  										>> %COMPUTERNAME%_result.txt
:END67
ECHO [+]W67 end            
del chkTimeout.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W68 start            
ECHO �� W-68 : ����� �۾��� �ǽɽ����� ����� ��ϵǾ� �ִ��� ����                      	>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ���ʿ��� ��ɾ ���� �� �ֱ����� ���� �۾��� ���� ���θ� �ֱ������� �����ϰ� ������ ��� ��ȣ >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
schtasks | findstr "Ready"                  							>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ�                    									>> %COMPUTERNAME%_result.txt
ECHO [+]W68 end            
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W69 start            
ECHO �� W-69 : ��å�� ���� �ý��� �α� ����                     					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : ���� ��å �ǰ� ���ؿ� ���� ���� ������ �Ǿ� �ִ� ��� ��ȣ                   	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
rem secpol.msc
type securityPolicy.txt | findstr "Audit"            					>> %COMPUTERNAME%_result.txt
type securityPolicy.txt | findstr "AuditObjectAccess" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "0" > nul
IF ERRORLEVEL 1 GOTO BAD69
type securityPolicy.txt | findstr "AuditAccountManage" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "1" > nul
IF ERRORLEVEL 1 GOTO BAD69
type securityPolicy.txt | findstr "AuditLogonEvents" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "1" > nul
IF ERRORLEVEL 1 GOTO BAD69
type securityPolicy.txt | findstr "AuditPrivilegeUse" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "0" > nul
IF ERRORLEVEL 1 GOTO BAD69
type securityPolicy.txt | findstr "AuditDSAccess" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "1" > nul
IF ERRORLEVEL 1 GOTO BAD69
type securityPolicy.txt | findstr "AuditLogonEvents" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "3" > nul
IF ERRORLEVEL 1 GOTO BAD69
type securityPolicy.txt | findstr "AuditLogonEvents" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "3" > nul
IF ERRORLEVEL 1 GOTO BAD69
type securityPolicy.txt | findstr "AuditSystemEvents" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "3" > nul
IF ERRORLEVEL 1 GOTO BAD69
type securityPolicy.txt | findstr "AuditPolicyChange" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "1" > nul
IF ERRORLEVEL 1 GOTO BAD69
type securityPolicy.txt | findstr "AuditProcessTracking" > chkAuditSetting.txt
type chkAuditSetting.txt | findstr "0" > nul
IF ERRORLEVEL 1 GOTO BAD69
IF NOT ERRORLEVEL 1 GOTO GOOD69
:BAD69
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
GOTO END69
:GOOD69
ECHO �� ��� : ��ȣ                     									>> %COMPUTERNAME%_result.txt
:END69
ECHO [+]W69 end
del chkAuditSetting.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W70 start
ECHO �� W-70 : �̺�Ʈ �α� ���� ����                      						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �ִ� �α� ũ�� "10,240KB �̻�"���� ����, "90�� ���� �̺�Ʈ ���"�� ������ ��� ��ȣ                   >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Security" | findstr /c:"MaxSize " >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Security" | findstr /c:"MaxSize " > chkSize.txt
for /f "tokens=3 delims= " %%L in (chkSize.txt) do set origin=%%L
set /A dec=0x%origin:~-6%
IF %dec% LSS 10485760 GOTO BAD70
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Security" | findstr "MaxSize" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Security" | findstr "Retention" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\eventlog\Security" | findstr "Retention" > chkRetention.txt
type chkRetention.txt | find "0xffffffff"
IF ERRORLEVEL 1 GOTO BAD70
IF NOT ERRORLEVEL 1 GOTO GOOD70
:BAD70
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
GOTO END70
:GOOD70
ECHO �� ��� : ��ȣ                     									>> %COMPUTERNAME%_result.txt
:END70
ECHO [+]W70 end
if exist chkRetention.txt del chkRetention.txt
if exist chkSize.txt del chkSize.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W71 start
ECHO �� W-71 : ���ݿ��� �̺�Ʈ �α� ���� ���� ����                  					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �α� ���͸��� ���ٱ��ѿ� Everyone ������ ���� ��� ��ȣ       			>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                                           					>> %COMPUTERNAME%_result.txt
icacls %windir%\system32\config   										>> %COMPUTERNAME%_result.txt
icacls %windir%\system32\config   > chkEveryone.txt
type chkEveryone.txt | findstr "Everyone" > nul
IF ERRORLEVEL 1 ECHO �� ��� : ��ȣ                         				>> %COMPUTERNAME%_result.txt
IF NOT ERRORLEVEL 1 ECHO �� ��� : ���                      				>> %COMPUTERNAME%_result.txt
ECHO [+]W71 end
del chkEveryone.txt
ECHO.                                             						>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------                			>> %COMPUTERNAME%_result.txt
ECHO.                                            						>> %COMPUTERNAME%_result.txt

ECHO [+]W72 start
ECHO �� W-72 : DoS ���� ��� ������Ʈ�� ����                      				>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Dos ��� ������Ʈ�� ���� �Ʒ��� ���� �����Ǿ� �ִ� ���                  	>> %COMPUTERNAME%_result.txt
ECHO SynAttackProtect = REG_DWORD 0(False)�� 1 �̻�                  		>> %COMPUTERNAME%_result.txt
ECHO EnableDeadGWDetect = REG_DWORD 1(True)�� 0                  		>> %COMPUTERNAME%_result.txt
ECHO KeepAliveTime = REG_DWORD 7,200,000(2�ð�)�� 300,000(5��)             >> %COMPUTERNAME%_result.txt
ECHO NoNameReleaseOnDemand = REG_DWORD 0(False)�� 1                  	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip\Parameters" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip\Parameters" > DDoSRegistry.txt

type DDoSRegistry.txt | findstr "SynAttackProtect" > nul
IF ERRORLEVEL 1 GOTO BAD72
type DDoSRegistry.txt | findstr "SynAttackProtect" > chkValue.txt
for /f "tokens=3 delims= " %%L in (chkValue.txt) do set value1=%%L
set /A getValue1=%value1:~-1%
IF %getValue1% LSS 1 GOTO BAD72

type DDoSRegistry.txt | findstr "EnableDeadGWDetect" > nul
IF ERRORLEVEL 1 GOTO BAD72
type DDoSRegistry.txt | findstr "EnableDeadGWDetect" > chkValue.txt
for /f "tokens=3 delims= " %%L in (chkValue.txt) do set value2=%%L
set /A getValue2=%value2:~-1%
IF %getValue2% NEQ 0 GOTO BAD72

type DDoSRegistry.txt | findstr "KeepAliveTime" > nul
IF ERRORLEVEL 1 GOTO BAD72
type DDoSRegistry.txt | findstr "KeepAliveTime" > chkValue.txt
for /f "tokens=3 delims= " %%L in (chkValue.txt) do set value3=%%L
set /A getValue3=%value3:~-6%
IF %getValue3% NEQ 300000 GOTO BAD72

type DDoSRegistry.txt | findstr "NoNameReleaseOnDemand" > nul
IF ERRORLEVEL 1 GOTO BAD72
type DDoSRegistry.txt | findstr "NoNameReleaseOnDemand" > chkValue.txt
for /f "tokens=3 delims= " %%L in (chkValue.txt) do set value4=%%L
set /A getValue4=%value4:~-1%
IF %getValue4% NEQ 1 GOTO BAD72

GOTO GOOD72
:BAD72
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
GOTO END72
:GOOD72
ECHO �� ��� : ��ȣ                  										>> %COMPUTERNAME%_result.txt
:END72
ECHO [+]W72 end
set "value1="
set "value2="
set "value3="
set "value4="
set "getValue1="
set "getValue2="
set "getValue3="
set "getValue4="
IF exist "chkValue.txt" del chkValue.txt
del DDoSRegistry.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W73 start
rem secpol.msc
ECHO �� W-73 : ����ڰ� ������ ����̹��� ��ġ �� �� ���� ��                      		>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "����ڰ� ������ ����̹��� ��ġ�� �� ���� �� " ��å�� ������ ��� ��ȣ          	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Providers\LanMan Print Services\Servers" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Providers\LanMan Print Services\Servers" > chkPrint.txt
for /f "tokens=3 delims= " %%L in (chkPrint.txt) do set value=%%L
set decValue=%value:~-1%
IF %decValue% NEQ 1 goto BAD73
IF %decValue% NEQ 0 goto GOOD73
:BAD73
ECHO Not prevent print install         									>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
goto END73
:GOOD73
ECHO �� ��� : ��ȣ                     									>> %COMPUTERNAME%_result.txt
:END73
ECHO [+]W73 end
set "value="
set "decValue="
del chkPrint.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W74 start
rem secpol.msc
rem microsoft network server: Disconnect clients when logon
rem microsoft network server: Amount of idletime
ECHO �� W-74 : ���� ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð�                      		>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "�α׿� �ð��� ����Ǹ� Ŭ���̾�Ʈ ���� ����" ��å�� "���"����, "���� ������ �ߴ��ϱ� ���� �ʿ��� ���� �ð�" ��å�� "15��"���� ������ ��� ��ȣ                  >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\LanmanServer\Parameters" >> chkSettings.txt
type chkSettings.txt | findstr "enableforcedlogoff" > chkLogoff.txt
type chkSettings.txt | findstr "enableforcedlogoff" 					>> %COMPUTERNAME%_result.txt
type chkSettings.txt | findstr "autodisconnect" > chkIdle.txt
type chkSettings.txt | findstr "autodisconnect" 						>> %COMPUTERNAME%_result.txt

for /f "tokens=3 delims= " %%L in (chkLogoff.txt) do set value=%%L
set getValue=%value:~-1%
IF %getValue% NEQ 1 GOTO BAD74

for /f "tokens=3 delims= " %%L in (chkIdle.txt) do set value=%%L
set /A getValue=%value:~-6%
IF %getValue% NEQ 15 GOTO BAD74
GOTO GOOD74

:BAD74
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
GOTO END74
:GOOD74
ECHO �� ��� : ��ȣ                     									>> %COMPUTERNAME%_result.txt
:END74
ECHO [+]W74 end
del chkSettings.txt
del chkLogoff.txt
del chkIdle.txt
set "value="
set "getValue="
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W75 start
ECHO �� W-75 : ��� �޽��� ����                      							>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �α׿� ��� �޽��� ���� �� ������ �����Ǿ� �ִ� ��� ��ȣ                   	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | find "legal" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | find "legal" >> chkMsg.txt

type chkMsg.txt | find "legalnoticecaption" > chkCaption.txt
type chkMsg.txt | find "legalnoticetext" > chkText.txt

for /f "tokens=3 delims= " %%L in (chkCaption.txt) do set value=%%L
IF "%value%"=="" goto BAD75
for /f "tokens=3 delims= " %%L in (chkText.txt) do set value=%%L
if "%value%"=="" goto BAD75
goto GOOD75
:BAD75
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
GOTO END75
:GOOD75
ECHO �� ��� : ��ȣ                     									>> %COMPUTERNAME%_result.txt
:END75
ECHO [+]W75 end
del chkMsg.txt
del chkCaption.txt
del chkText.txt
set "value="
set "getValue="
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W76 start
ECHO �� W-76 : ����ں� Ȩ ���丮 ���� ����                      				>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Ȩ ���͸��� Everyone ������ ���� ��� (All Users, Default User ���͸� ����) ��ȣ                  >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
REM get all users
net user > totalUsers.txt
for /f "skip=4 tokens=* delims= " %%L in (totalUsers.txt) do (
  for %%K in (%%L) do (
    echo %%K >> users.txt
 )
)
REM chk exist user folder
for /f %%J in (users.txt) do (
  if exist "C:\Users\%%J" (
    icacls C:\Users\%%J 												>> %COMPUTERNAME%_result.txt
    icacls C:\Users\%%J >> chkEveryone.txt
  )
)
type chkEveryone.txt | findstr "Everyone"
IF ERRORLEVEL 1 GOTO GOOD76
:BAD76
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
GOTO END76
:GOOD76
ECHO �� ��� : ��ȣ                     									>> %COMPUTERNAME%_result.txt
:END76
ECHO [+]W76 end
del totalUsers.txt
del chkEveryone.txt
del users.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

rem secpol.msc -> Network security: LAN Manager authentication level
ECHO [+]W77 start
ECHO �� W-77 : LAN Manager ���� ����                      					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "LAN Manager ���� ����" ��å�� "NTLMv2 ���丸 ����"�� �����Ǿ� �ִ� ��� ��ȣ                  >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | findstr "LmCompatibilityLevel" > chkLM.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" | findstr "LmCompatibilityLevel" >> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 (
  ECHO Not set LAN Manager Authentication level. 						>> %COMPUTERNAME%_result.txt
  GOTO BAD77
)
for /f "tokens=3 delims= " %%L in (chkLM.txt) do set value=%%L
IF %value% LSS 3 GOTO BAD77
GOTO GOOD77
:BAD77
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
goto END77
:GOOD77
ECHO �� ��� : ��ȣ                  										>> %COMPUTERNAME%_result.txt
:END77
ECHO [+]W77 end
del chkLM.txt
set "value="
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                									>> %COMPUTERNAME%_result.txt

ECHO [+]W78 start
ECHO �� W-78 : ���� ä�� ������ ������ ��ȣȭ �Ǵ� ����                      			>> %COMPUTERNAME%_result.txt
ECHO �� ���� : 3���� ��å�� "���"���� �Ǿ� �ִ� ��� ��ȣ                   			>> %COMPUTERNAME%_result.txt
ECHO ���� ä�� �����͸� ������ ��ȣȭ �Ǵ�, ����(�׻�)                   				>> %COMPUTERNAME%_result.txt
ECHO ���� ä�� �����͸� ������ ���� (�����ϸ�)                   					>> %COMPUTERNAME%_result.txt
ECHO ���� ä�� �����͸� ������ ��ȣȭ (�����ϸ�)                   					>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "RequireSignOrSeal" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "SealSecureChannel" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "SignSecureChannel" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "RequireSignOrSeal" > chkRequire.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "SealSecureChannel" > chkSeal.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "SignSecureChannel" > chkSign.txt

for /f "tokens=3 delims= " %%L in (chkRequire.txt) do set value=%%L
IF %value% NEQ 1 GOTO BAD78
for /f "tokens=3 delims= " %%L in (chkSeal.txt) do set value=%%L
IF %value% NEQ 1 GOTO BAD78
for /f "tokens=3 delims= " %%L in (chkSign.txt) do set value=%%L
IF %value% NEQ 1 GOTO BAD78
GOTO GOOD78
:BAD78
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
GOTO END78
:GOOD78
ECHO �� ��� : ��ȣ                  										>> %COMPUTERNAME%_result.txt
:END78
ECHO [+]W78 end
del chkRequire.txt
del chkSeal.txt
del chkSign.txt
set "%value%="
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W79 start
ECHO �� W-79 : ���� �� ���͸� ��ȣ                      						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : NTFS ���� �ý����� ����ϴ� ��� ��ȣ                   				>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
ECHO \How to check\                  									>> %COMPUTERNAME%_result.txt
ECHO CMD\ diskpart                        								>> %COMPUTERNAME%_result.txt
ECHO DISKPART\ select volumne=c or d or f ...      						>> %COMPUTERNAME%_result.txt
ECHO DISKPART\ filesystems                  							>> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ�                     								>> %COMPUTERNAME%_result.txt
ECHO [+]W79 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]W80 start
ECHO �� W-80 : ��ǻ�� ���� ��ȣ �ִ� ��� �Ⱓ                      				>> %COMPUTERNAME%_result.txt
ECHO �� ���� : "��ǻ�� ���� ��ȣ ���� ��� ����" ��å�� ������� ������, "��ǻ�� ���� ��ȣ �ִ� ���Ⱓ" ��å�� "90��"�� �����Ǿ� ���� ���� ��� ��ȣ >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "DisablePasswordChange" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "MaximumPasswordAge" >> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "DisablePasswordChange" > chkChange.txt
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Netlogon\Parameters" | findstr "MaximumPasswordAge" > chkAge.txt

for /f "tokens=3 delims= " %%L in (chkChange.txt) do set value=%%L
IF %value% NEQ 0 GOTO BAD80
for /f "tokens=3 delims= " %%L in (chkAge.txt) do set value=%%L
set /A getValue=0x%value:~-2%
IF %getValue% NEQ 90 GOTO BAD80
GOTO GOOD80
:BAD80
ECHO �� ��� : ���                     									>> %COMPUTERNAME%_result.txt
GOTO END80
:GOOD80
ECHO �� ��� : ��ȣ                     									>> %COMPUTERNAME%_result.txt
:END80
ECHO [+]W80 end
del chkChange.txt
del chkAge.txt
set "value="
set "getValue="
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

echo [+]W81 start
ECHO �� W-81 : �������α׷� ��� �м�                      						>> %COMPUTERNAME%_result.txt
ECHO �� ���� : �������α׷� ����� ���������� �˻��ϰ� ���ʿ��� ���� üũ������ �� ��� ��ȣ      	>> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> %COMPUTERNAME%_result.txt
ECHO �� ��� : ���ͺ� �ʿ�                     								>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt
echo [+]W81 end

echo [+]W82 start
ECHO �� W-82 : Windows ���� ��� ���                      					>> %COMPUTERNAME%_result.txt
ECHO �� ���� : Windows ���� ��带 ����ϰ� sa������ ��Ȱ��ȭ�Ǿ� �ִ� ��� sa ���� ��� �� ������ ��ȣ��å�� ������ ��� ��ȣ                   >> %COMPUTERNAME%_result.txt
ECHO �� ��Ȳ                               								>> %COMPUTERNAME%_result.txt
SC query "SQL" 															>> %COMPUTERNAME%_result.txt
IF ERRORLEVEL 1 (
  ECHO Not exist SQL Server. 											>> %COMPUTERNAME%_result.txt
  goto GOOD82
)
IF NOT ERRORLEVEL 1 (
  ECHO �� ��� : ���ͺ� �ʿ�                     								>> %COMPUTERNAME%_result.txt
  GOTO END82
)
:GOOD82
ECHO �� ��� : ��ȣ               											>> %COMPUTERNAME%_result.txt
:END82
ECHO [+]W82 end
ECHO.                                 									>> %COMPUTERNAME%_result.txt
ECHO ----------------------------------------    						>> %COMPUTERNAME%_result.txt
ECHO.                                 									>> %COMPUTERNAME%_result.txt

ECHO [+]batch end
DEL securityPolicy.txt

:EOF