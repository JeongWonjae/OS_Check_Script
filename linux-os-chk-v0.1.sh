#!/bin/sh
RESULT_FILE="result.txt"
echo "Linux(CentOS 6.6) Vulnerability check start" > $RESULT_FILE 2>&1
splitLine="---------------------------------------"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-01] start"
echo "[U-01] root 계정의 원격 접속 제한" >> $RESULT_FILE

if [ -f "/etc/pam.d/remote" ]; then
	chkpam=`cat /etc/pam.d/remote | egrep -v '^#|^$' | grep -w "pam_securetty.so"`
else
	TELNET=0
fi

if [ -f "/etc/securetty" ] && [ "$chkpam"!="" ]; then
	echo "Configured [pam_securetty.so]" >> $RESULT_FILE
	chkpts=`cat /etc/securetty | egrep -v '^#|^$' | grep -i "pts"`
	if [ "$chkpts" != "" ]; then
		TELNET=0
		echo "Exist [pts] user" >> $RESULT_FILE
	else
		TELNET=1
		echo "Not Exist [pts] user" >> $RESULT_FILE
	fi
else
	TELNET=0
	echo "Not Configured [pam_securetty.so] or File open error [/etc/securetty]" >> $RESULT_FILE
fi

if [ -f /etc/ssh/sshd_config ]; then
	chkssh=`cat /etc/ssh/sshd_config | grep -v '^#' | grep -i "^PermitRemoteLogin"`
	chkssh_value=`echo $chkssh | awk '{ print $2 }'`
	if [ "$chkssh_value" == "no" ]; then
		SSH=1
		echo "[PermitRemoteLogin] value set 'no'" >> $RESULT_FILE
	elif [ "$chkssh" == "" ]; then
		SSH=1
		echo "Not Exist [PermitRemoteLogin] value" >> $RESULT_FILE
	else
		SSH=0
		echo "[PermitRemoteLogin] value not set 'no'" >> $RESULT_FILE
	fi
else
	SSH=0
	echo "Open file error [/etc/ssh/sshd_config]" >> $RESULT_FILE
fi

if [ $TELNET == 1 ] && [ $SSH == 1 ]; then
	echo "[U-01] 양호" >> $RESULT_FILE
else
	echo "[U-01] 취약" >> $RESULT_FILE
fi
echo $splitLine >> $RESULT_FILE
unset TELNET;
unset SSH;
unset chkpam;
unset chkpts;
unset chkssh;
unset chkssh_vaule;
echo "[U-01] end"


echo "[U-02] start"
echo "[U-02] 패스워드 복잡성 설정" >> $RESULT_FILE

chkPWLength=`cat /etc/login.defs | grep -v '^#' | grep -i 'PASS_'`
chkPWComplex=`cat /etc/pam.d/system-auth | grep -i 'password' | grep -i 'requisite' | grep -i 'credit'`
echo $chkPWLength >> $RESULT_FILE
echo $chkPWComplex >> $RESULT_FILE

PASS_MAX_DAYS=`echo $chkPWLength | awk '{ print $2 }'` #not used
PASS_MIN_DAYS=`echo $chkPWLength | awk '{ print $4 }'` #not used
PASS_MIN_LEN=`echo $chkPWLength | awk '{ print $6 }'`

if [ $PASS_MIN_LEN -ge 8 ]; then
	LENGTH=1
else
	LENGTH=0
	echo "Not sufficient password length" >> $RESULT_FILE
fi

if [ "$chkPWComplex" != "" ]; then
	creditCount=`echo $chkPWComplex | grep -o '=-1' | wc -l`
	if [ $creditCount -eq 3 ]; then
		COMPLEX=1
	else
		COMPLEX=0
		echo "Not set sufficient complex settings" >> $RESULT_FILE
	fi
else 
	COMPLEX=0
	echo "Not set complex settings" >> $RESULT_FILE
fi

if [ $COMPLEX == 1 ] && [ $LENGTH == 1 ]; then
	echo "[U-02] 양호" >> $RESULT_FILE
else
	echo "[U-02] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset chkPWLength
unset chkPWComplex
unset PASS_MIN_LEN
unset LENGTH
unset creditCount
unset COMPLEX
echo "[U-02] end"


echo "[U-03] start"
echo "[U-03] 계정 잠금 임계값 설정" >> $RESULT_FILE
cat /etc/pam.d/system-auth | grep -i pam_tally.so >> $RESULT_FILE
chkSettings=`cat /etc/pam.d/system-auth | grep -i pam_tally.so`
tryMaxLogin=`echo $chkSettings | awk '{for(i=1;i<=NF;i++){if($i~/deny=/) print $i}}'`
tryMaxLoginValue=`echo $tryMaxLogin | awk -F '=' '{ print $2 }'`

if [ "$tryMaxLogin" != "" ]; then
	if [ $tryMaxLoginValue -le 5 ]; then
		echo "[U-03] 양호" >> $RESULT_FILE
	else
		echo "Not sufficient try login lock setting" >> $RESULT_FILE
		echo "[U-03] 취약" >> $RESULT_FILE
	fi
else
	echo "Not set try login lock setting" >> $RESULT_FILE
	echo "[U-03] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset chkSettings
unset tryMaxLogin
unset tryMaxLoginValue
echo "[U-03] end"


echo "[U-04] start"
echo "[U-04] 패스워드 파일 보호" >> $RESULT_FILE
cat /etc/passwd | grep -i 'root:' >> $RESULT_FILE
chkEncryption=`cat /etc/passwd | grep -i 'root:' `
chkEncryption2ndField=`echo $chkEncryption | awk -F ":" '{ print $2 }'`

if [ -f "/etc/shadow" ]; then
	if [ $chkEncryption2ndField == "x" ]; then
		echo "[U-04] 양호" >> $RESULT_FILE
	else
		echo "Not configured password encryption" >> $RESULT_FILE
		echo "[U-04] 취약" >> $RESULT_FILE
	fi
else
	echo "Not exist /etc/shadow file" >> $RESULT_FILE
	echo "[U-04] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset chkEncryption
unset chkEncryption2ndField
echo "[U-04] end"


echo "[U-05] start"
echo "[U-05] root홈, 패스 디렉터리 권한 및 패스 설정" >> $RESULT_FILE
echo 'Lookup $PATH in system ' >> $RESULT_FILE
echo $PATH >> $RESULT_FILE
RESULT=1
chkPath=`echo $PATH | grep -i '\.'`
if [ "$chkPath" != "" ]; then
	RESULT=0
fi
chkPath=`echo $PATH | grep -i '::'`
if [ "$chkPath" != "" ]; then
	RESULT=0
fi
echo 'Lookup $PATH in /etc/profile ' >> $RESULT_FILE
cat /etc/profile | grep -i 'PATH=' >> $RESULT_FILE
chkPath=`cat /etc/profile | grep -i 'PATH=' | grep -i '\.'`
if [ "$chkPath" != "" ]; then
	RESULT=0
fi
echo 'Lookup $PATH in $HOME/.bash_profile ' >> $RESULT_FILE
cat $HOME/.bash_profile | grep -i 'PATH=' >> $RESULT_FILE
chkPath=`cat $HOME/.bash_profile | grep -i 'PATH=' | grep -i '\.'`
#if [ "$chkPath" != "" ]; then
#	RESULT=0
#fi

if [ $RESULT == 1 ]; then
	echo "[U-05] 양호" >> $RESULT_FILE
else
	echo "[U-05] 취약" >> $RESULT_FILE
fi
echo $splitLine >> $RESULT_FILE
unset RESULT
unset chkPath
echo "[U-05] end"

#결과에 영향 없는 에러메시지 뜸
echo "[U-06] start"
echo "[U-06] 파일 및 디렉터리 소유자 지정" >> $RESULT_FILE
RESULT=1
nouser=`find / -nouser` > nul
if [ "$nouser" != "" ]; then
	RESULT=0
	echo "Exist nouser files" >> $RESULT_FILE
	find / -nouser >> $RESULT_FILE
fi
nogroup=`find / -nogroup` > nul
if [ "$nogroup" != "" ]; then
	RESULT=0
	echo "Exist nogroup files" >> $RESULT_FILE
	find / -nogroup >> $RESULT_FILE
fi

if [ $RESULT == 1 ]; then
	echo "[U-06] 양호" >> $RESULT_FILE
else
	echo "[U-06] 취약" >> $RESULT_FILE
fi
echo $splitLine >> $RESULT_FILE
unset RESULT
unset nouser
unset nogroup
echo "[U-06] end"

echo "[U-07] start"
echo "[U-07] /etc/passwd 파일 소유자 및 권한 설정" >> $RESULT_FILE

function permissionPoint(){
	echo $1
	if [ "$1" == "r" ]; then
		return 4
	elif [ "$1" == "w" ]; then
		return 2
	elif [ "$1" == "x" ]; then
		return 1
	else
		return 0
	fi
}

ls -l /etc/passwd >> $RESULT_FILE
permission=`ls -l /etc/passwd | awk '{ print $1 }'`
permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
permission_ur=$?
permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
permission_uw=$?
permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
permission_ux=$?
permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
permission_gr=$?
permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
permission_gw=$?
permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
permission_gx=$?
permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
permission_or=$?
permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
permission_ow=$?
permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
permission_ox=$?
permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

permissionTotal=$permission_user$permission_group$permission_other

if [ $permissionTotal -le 644 ]; then
	echo "[U-07] 양호" >> $RESULT_FILE
else
	echo "[U-07] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset permission
unset permission_ur
unset permission_uw
unset permission_ux
unset permission_gr
unset permission_gw
unset permission_gx
unset permission_or
unset permission_ow
unset permission_ox
unset permission_user
unset permission_group
unset permission_other
unset permissionTotal
echo "[U-07] end"


echo "[U-08] start"
echo "[U-08] 파일 소유자 및 권한 설정" >> $RESULT_FILE

ls -l /etc/shadow >> $RESULT_FILE

if [ -f "/etc/shadow" ]; then
	permission=`ls -l /etc/shadow | awk '{ print $1 }'`
	permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
	permission_ur=$?
	permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
	permission_uw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
	permission_ux=$?
	permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

	permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
	permission_gr=$?
	permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
	permission_gw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
	permission_gx=$?
	permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

	permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
	permission_or=$?
	permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
	permission_ow=$?
	permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
	permission_ox=$?

	permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

	permissionTotal=$permission_user$permission_group$permission_other
	permission_owner=`ls -l /etc/shadow | awk '{ print $3 }'`
else
	echo "Not exist /etc/shadow file" >> $RESULT_FILE
	permissionTotal=000
fi

if [ $permissionTotal -eq 400 ] && [ "$permission_owner" == "root" ]; then
	echo "[U-08] 양호" >> $RESULT_FILE
else
	echo "[U-08] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset permission
unset permission_ur
unset permission_uw
unset permission_ux
unset permission_gr
unset permission_gw
unset permission_gx
unset permission_or
unset permission_ow
unset permission_ox
unset permission_user
unset permission_group
unset permission_other
unset permissionTotal
unset permission_owner
echo "[U-08] end"


echo "[U-09] start"
echo "[U-09] /etc/hosts 파일 소유자 및 권한 설정" >> $RESULT_FILE

ls -l /etc/hosts >> $RESULT_FILE
permission=`ls -l /etc/hosts | awk '{ print $1 }'`
permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
permission_ur=$?
permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
permission_uw=$?
permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
permission_ux=$?
permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
permission_gr=$?
permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
permission_gw=$?
permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
permission_gx=$?
permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
permission_or=$?
permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
permission_ow=$?
permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
permission_ox=$?
permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

permissionTotal=$permission_user$permission_group$permission_other
permission_owner=`ls -l /etc/shadow | awk '{ print $3 }'`

if [ $permissionTotal -eq 600 ] && [ "$permission_owner" == "root" ]; then
	echo "[U-09] 양호" >> $RESULT_FILE
else
	echo "[U-09] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset permission
unset permission_ur
unset permission_uw
unset permission_ux
unset permission_gr
unset permission_gw
unset permission_gx
unset permission_or
unset permission_ow
unset permission_ox
unset permission_user
unset permission_group
unset permission_other
unset permissionTotal
unset permission_owner
echo "[U-09] end"


echo "[U-10] start"
echo "[U-10] /etc/(x)inetd.conf 파일 소유자 및 권한 설정" >> $RESULT_FILE

if [ -f "/etc/xinetd.conf" ]; then
	ls -l /etc/xinetd.conf >> $RESULT_FILE
	permission=`ls -l /etc/xinetd.conf | awk '{ print $1 }'`
	permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
	permission_ur=$?
	permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
	permission_uw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
	permission_ux=$?
	permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

	permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
	permission_gr=$?
	permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
	permission_gw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
	permission_gx=$?
	permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

	permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
	permission_or=$?
	permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
	permission_ow=$?
	permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
	permission_ox=$?

	permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

	permissionTotal=$permission_user$permission_group$permission_other
	permission_owner=`ls -l /etc/xinetd.conf | awk '{ print $3 }'`
else
	echo "Not exist /etc/xinetd.conf file" >> $RESULT_FILE
	permissionTotal=000
fi

if [ $permissionTotal -eq 600 ] && [ "$permission_owner" == "root" ]; then
	echo "[U-10] 양호" >> $RESULT_FILE
else
	echo "[U-10] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset permission
unset permission_ur
unset permission_uw
unset permission_ux
unset permission_gr
unset permission_gw
unset permission_gx
unset permission_or
unset permission_ow
unset permission_ox
unset permission_user
unset permission_group
unset permission_other
unset permissionTotal
unset permission_owner
echo "[U-10] end"


echo "[U-11] start"
echo "[U-11] /etc/syslog.conf 파일 소유자 및 권한 설정" >> $RESULT_FILE

RESULT=0

if [ -f "/etc/syslog.conf" ]; then
	ls -l /etc/syslog.conf >> $RESULT_FILE
	RESULT=1
	permission=`ls -l /etc/syslog.conf | awk '{ print $1 }'`
	permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
	permission_ur=$?
	permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
	permission_uw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
	permission_ux=$?
	permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

	permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
	permission_gr=$?
	permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
	permission_gw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
	permission_gx=$?
	permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

	permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
	permission_or=$?
	permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
	permission_ow=$?
	permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
	permission_ox=$?

	permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

	permissionTotal=$permission_user$permission_group$permission_other
	permission_owner=`ls -l /etc/syslog.conf | awk '{ print $3 }'`
else
	echo "Not exist /etc/syslog.conf file" >> $RESULT_FILE
	permissionTotal=000
fi

if [ $RESULT -eq 1 ]; then
	if [ $permissionTotal -le 644 ]; then
		RESULT=1
	else
		echo "Permission is not set below 644" >> $RESULT_FILE
		RESULT=0
	fi

	if [ "$permission_owner" == "root" ] || [ "$permission_owner" == "bin" ] || [ "$permission_owner" == "sys" ]; then
		RESULT=1
	else
		echo "Owner is not set 'root' or 'bin' or 'sys'" >> $RESULT_FILE
		RESULT=0
	fi
fi

if [ $RESULT -eq 1 ]; then
	echo "[U-11] 양호" >> $RESULT_FILE
else
	echo "[U-11] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset permission
unset permission_ur
unset permission_uw
unset permission_ux
unset permission_gr
unset permission_gw
unset permission_gx
unset permission_or
unset permission_ow
unset permission_ox
unset permission_user
unset permission_group
unset permission_other
unset permissionTotal
unset permission_owner
unset RESULT
echo "[U-11] end"


echo "[U-12] start"
echo "[U-12] /etc/services 파일 소유자 및 권한 설정" >> $RESULT_FILE

RESULT=0

if [ -f "/etc/services" ]; then
	ls -l /etc/services >> $RESULT_FILE
	RESULT=1
	permission=`ls -l /etc/services | awk '{ print $1 }'`
	permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
	permission_ur=$?
	permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
	permission_uw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
	permission_ux=$?
	permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

	permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
	permission_gr=$?
	permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
	permission_gw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
	permission_gx=$?
	permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

	permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
	permission_or=$?
	permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
	permission_ow=$?
	permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
	permission_ox=$?

	permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

	permissionTotal=$permission_user$permission_group$permission_other
	permission_owner=`ls -l /etc/services | awk '{ print $3 }'`
else
	echo "Not exist /etc/services file" >> $RESULT_FILE
	permissionTotal=000
fi

if [ $RESULT -eq 1 ]; then
	if [ $permissionTotal -le 644 ]; then
		RESULT=1
	else
		echo "Permission is not set below 644" >> $RESULT_FILE
		RESULT=0
	fi

	if [ "$permission_owner" == "root" ] || [ "$permission_owner" == "bin" ] || [ "$permission_owner" == "sys" ]; then
		RESULT=1
	else
		echo "Owner is not set 'root' or 'bin' or 'sys'" >> $RESULT_FILE
		RESULT=0
	fi
fi

if [ $RESULT -eq 1 ]; then
	echo "[U-12] 양호" >> $RESULT_FILE
else
	echo "[U-12] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset permission
unset permission_ur
unset permission_uw
unset permission_ux
unset permission_gr
unset permission_gw
unset permission_gx
unset permission_or
unset permission_ow
unset permission_ox
unset permission_user
unset permission_group
unset permission_other
unset permissionTotal
unset permission_owner
unset RESULT
echo "[U-12] end"


echo "[U-13] start"
echo "[U-13] UID, SGID, Sticky bit 설정 및 권한 설정" >> $RESULT_FILE
echo "주요 실행파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우 양호" >> $RESULT_FILE
echo "1. 인터뷰를 통해 주요 실행파일 목록화"	>> $RESULT_FILE
echo "2. #ls -alL [file_name] | awk '{ print \$1 }' | grep -i 's'"	>> $RESULT_FILE
echo "[U-13] 인터뷰 필요" >> $RESULT_FILE
echo $splitLine >> $RESULT_FILE
echo "[U-13] end"


echo "[U-14] start"
echo "[U-14] 사용자, 시스템 시작파일 및 환경파일 소유자 및 권 한 설정" >> $RESULT_FILE
echo "홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고, 홈 디렉터리 환경변수 파일에 root와 소유자만 쓰기 권한이 부여된 경우 양호" >> $RESULT_FILE
echo "1. 인터뷰를 통해 root 또는 사용자 계정에 존재하는 홈 디렉터리 환경변수 파일 목록화"	>> $RESULT_FILE
echo "2. #ls -l [file_path/file_name]"	>> $RESULT_FILE
echo "[U-14] 인터뷰 필요" >> $RESULT_FILE
echo $splitLine >> $RESULT_FILE
echo "[U-14] end"


echo "[U-15] start"
echo "[U-15] world writable 파일 점검"  >> $RESULT_FILE
echo "world writable 파일 상위 20개" >> $RESULT_FILE
find / -type f -perm -2 -ls | head -20 >> $RESULT_FILE
echo "world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 확인하고 있는 경우 양호" >> $RESULT_FILE
echo "1. 인터뷰를 통해 world writable 설정 이유 확인" >> $RESULT_FILE
echo "2. 파일을 삭제하거나, 일반 사용자 쓰기 권한 제거" >> $RESULT_FILE
echo "[U-15] 인터뷰 필요" >> $RESULT_FILE
echo $splitLine >> $RESULT_FILE
echo "[U-15] end"


echo "[U-16] start"
echo "[U-16] /dev에 존재하지 않는 device 파일 점검" >> $RESULT_FILE
echo "dev 디렉터리에 존재하지 않는 device 파일이 없을 경우 양호" >> $RESULT_FILE
echo "1. #find /dev -type f -exec ls -l {} \;" >> $RESULT_FILE
echo "2. 인터뷰를 통해 존재하지 않는 device 파일 목록화" >> $RESULT_FILE
echo "3. device 파일 제거" >> $RESULT_FILE
echo "[U-16] 인터뷰 필요" >> $RESULT_FILE
echo $splitLine >> $RESULT_FILE
echo "[U-16] end"


echo "[U-17] start"
echo "[U-17] \$HOME/.rhosts, hosts.equiv 사용 금지" >> $RESULT_FILE
HOSTS=0
RHOSTS=0

echo "1. $HOME/.rhosts file" >> $RESULT_FILE
if [ -f "/etc/hosts.equiv" ]; then
	HOSTS=0
	ls -l /etc/hosts.equiv >> $RESULT_FILE
	permission=`ls -l /etc/hosts.equiv | awk '{ print $1 }'`
	permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
	permission_ur=$?
	permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
	permission_uw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
	permission_ux=$?
	permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

	permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
	permission_gr=$?
	permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
	permission_gw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
	permission_gx=$?
	permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

	permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
	permission_or=$?
	permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
	permission_ow=$?
	permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
	permission_ox=$?

	permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

	permissionTotal=$permission_user$permission_group$permission_other
	permission_owner=`ls -l /etc/hosts.equiv | awk '{ print $3 }'`

	if [ $permissionTotal -le 600 ] && [ "$permission_owner" == "root" ]; then
		HOSTS=1
	else
		echo "Not set below 600 permission or owner 'root'" >> $RESULT_FILE
		HOSTS=0
	fi
	
	content=`cat /etc/hosts.equiv | grep '+'`
	if [ "$content" != "" ]; then
		HOSTS=1
	else
		HOSTS=0
		echo "Set '+' options" >> $RESULT_FILE
	fi

else
	HOSTS=0
	echo "Not exist /etc/hosts.equiv file" >> $RESULT_FILE
fi


echo "2. /$HOME/.rhosts file" >> $RESULT_FILE
if [ -f "/$HOME/.rhosts" ]; then

	RHOSTS=0
	ls -l /$HOME/.rhosts >> $RESULT_FILE
	permission=`ls -l /$HOME/.rhosts | awk '{ print $1 }'`
	permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
	permission_ur=$?
	permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
	permission_uw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
	permission_ux=$?
	permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

	permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
	permission_gr=$?
	permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
	permission_gw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
	permission_gx=$?
	permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

	permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
	permission_or=$?
	permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
	permission_ow=$?
	permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
	permission_ox=$?

	permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

	permissionTotal=$permission_user$permission_group$permission_other
	permission_owner=`ls -l /$HOME/.rhosts | awk '{ print $3 }'`

	if [ $permissionTotal -le 600 ] && [ "$permission_owner" == "root" ]; then
		RHOSTS=1
	else
		echo "Not set below 600 permission or owner 'root'" >> $RESULT_FILE
		RHOSTS=0
	fi
	
	content=`cat /$HOME/.rhosts | grep '+'`
	if [ "$content" != "" ]; then
		RHOSTS=1
	else
		RHOSTS=0
		echo "Set '+' options" >> $RESULT_FILE
	fi

else
	RHOSTS=0
	echo "Not exist /$HOME/.rhosts file" >> $RESULT_FILE
fi

if [ $RHOSTS -eq 1 ] && [ $HOSTS -eq 1 ]; then
	echo "[U-17] 양호" >> $RESULT_FILE
else
	echo "[U-17] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset permission
unset permission_ur
unset permission_uw
unset permission_ux
unset permission_gr
unset permission_gw
unset permission_gx
unset permission_or
unset permission_ow
unset permission_ox
unset permission_user
unset permission_group
unset permission_other
unset permissionTotal
unset permission_owner
unset RHOSTS
unset HOSTS
echo "[U-17] end"


echo "[U-18] start"
echo "[U-18] 접속 IP 및 포트 제한" >> $RESULT_FILE
echo "접속을 허용할 특정 호스트에 대한 IP 주소 및 포트 제한을 설정한 경우" >> $RESULT_FILE
echo "1. 인터뷰를 통해 허용할 특정 호스트 IP 주소 및 포트 목록화" >> $RESULT_FILE
echo "2. TCP Wraper 사용할 경우: #cat /etc/hosts.deny, cat /etc/hosts.allow 파 일 All deny 적용 확인 및 접근 허용 IP 적절성 확인" >> $RESULT_FILE
echo "3. IPtables 사용할 경우: #iptables -L 확인" >> $RESULT_FILE
echo "[U-18] 인터뷰 필요" >> $RESULT_FILE
echo $splitLine >> $RESULT_FILE
echo "[U-18] end"

echo "[U-19] start"
echo "[U-19] Finger 서비스 비활성화" >> $RESULT_FILE
service=`ls -alL /etc/xinetd.d/* | grep "finger"`
if [ "$service" == "" ]; then
	echo "[U-19] 양호" >> $RESULT_FILE
else
	echo "[U-19] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset service
echo "[U-19] end"


echo "[U-20] start"
echo "[U-20] Anonymous FTP 비활성화" >> $RESULT_FILE
ftpuser=`cat /etc/passwd | grep 'ftp'`
if [ "$ftpuser" == "" ]; then
	echo "[U-20] 양호" >> $RESULT_FILE
else
	echo "[U-20] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset ftpuser
echo "[U-20] end"


echo "[U-21] start"
echo "[U-21] r 계열 서비스 비활성화" >> $RESULT_FILE
service=`ls -alL /etc/xinetd.d/* | egrep 'rsh|rlogin|rexec' | egrep -v 'grep|klogin|kshell|kexec'`
if [ "$service" == "" ]; then
	echo "[U-21] 양호" >> $RESULT_FILE
else
	echo "[U-21] 취약" >> $RESULT_FILE
fi
echo $splitLine >> $RESULT_FILE
unset service
echo "[U-21] end"


echo "[U-22] start"
echo "[U-22] cron 파일 소유자 및 권한 설정" >> $RESULT_FILE
ALLOW=0
DENY=0

echo "1. /etc/cron.allow file" >> $RESULT_FILE
if [ -f "/etc/cron.allow" ]; then
	ALLOW=1
	ls -l /etc/cron.allow >> $RESULT_FILE
	permission=`ls -l /etc/cron.allow | awk '{ print $1 }'`
	permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
	permission_ur=$?
	permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
	permission_uw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
	permission_ux=$?
	permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

	permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
	permission_gr=$?
	permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
	permission_gw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
	permission_gx=$?
	permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

	permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
	permission_or=$?
	permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
	permission_ow=$?
	permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
	permission_ox=$?

	permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

	permissionTotal=$permission_user$permission_group$permission_other
	permission_owner=`ls -l /etc/cron.allow | awk '{ print $3 }'`

	if [ $permissionTotal -le 640 ] && [ "$permission_owner" == "root" ]; then
		ALLOW=1
	else
		echo "Not set below 640 permission or owner 'root'" >> $RESULT_FILE
		ALLOW=0
	fi

else
	ALLOW=0
	echo "Not exist /etc/cron.allow file" >> $RESULT_FILE
fi

echo "2. /etc/cron.deny file" >> $RESULT_FILE
if [ -f "/etc/cron.deny" ]; then
	DENY=1
	ls -l /etc/cron.deny >> $RESULT_FILE
	permission=`ls -l /etc/cron.deny | awk '{ print $1 }'`
	permissionPoint `echo $permission | awk -F '' '{ print $2 }'` > nul
	permission_ur=$?
	permissionPoint `echo $permission | awk -F '' '{ print $3 }'` > nul
	permission_uw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $4 }'` > nul
	permission_ux=$?
	permission_user=`expr $permission_ur \+ $permission_uw \+ $permission_ux`

	permissionPoint `echo $permission | awk -F '' '{ print $5 }'` > nul
	permission_gr=$?
	permissionPoint `echo $permission | awk -F '' '{ print $6 }'` > nul
	permission_gw=$?
	permissionPoint `echo $permission | awk -F '' '{ print $7 }'` > nul
	permission_gx=$?
	permission_group=`expr $permission_gr \+ $permission_gw \+ $permission_gx`

	permissionPoint `echo $permission | awk -F '' '{ print $8 }'` > nul
	permission_or=$?
	permissionPoint `echo $permission | awk -F '' '{ print $9 }'` > nul
	permission_ow=$?
	permissionPoint `echo $permission | awk -F '' '{ print $10 }'` > nul
	permission_ox=$?

	permission_other=`expr $permission_or \+ $permission_ow \+ $permission_ox`

	permissionTotal=$permission_user$permission_group$permission_other
	permission_owner=`ls -l /etc/cron.deny | awk '{ print $3 }'`

	if [ $permissionTotal -le 640 ] && [ "$permission_owner" == "root" ]; then
		DENY=1
	else
		echo "Not set below 640 permission or owner 'root'" >> $RESULT_FILE
		DENY=0
	fi

else
	DENY=0
	echo "Not exist /etc/cron.deny file" >> $RESULT_FILE
fi

if [ $ALLOW -eq 1 ] && [ $DENY -eq 1 ]; then
	echo "[U-22] 양호" >> $RESULT_FILE
else
	echo "[U-22] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset abc
echo "[U-22] end"



echo "[U-23] start"
echo "[U-23] DoS 공격에 취약한 서비스 비활성화" >> $RESULT_FILE

echo "1. echo 서비스" >> $RESULT_FILE
serviceECHO=0
servicePath=`find /etc/xinetd.d/ -name 'echo'`
if [ "$servicePath" != "" ]; then
	serviceSetting=`cat $servicePath | grep -i 'disable' | grep -i 'yes'`
	if [ "$serviceSetting" != "" ]; then
		echo "Disabled ECHO Service" >> $RESULT_FILE
		serviceECHO=1
	else
		echo "Activate ECHO Service" >> $RESULT_FILE
		serviceECHO=0
	fi
else
	serviceECHO=1
	echo "Not installed ECHO Service" >> $RESULT_FILE
fi
	
echo "2. discard 서비스" >> $RESULT_FILE
serviceDISCARD=0
servicePath=`find /etc/xinetd.d/ -name 'discard'`
if [ "$servicePath" != "" ]; then
	serviceSetting=`cat $servicePath | grep -i 'disable' | grep -i 'yes'`
	if [ "$serviceSetting" != "" ]; then
		echo "Disable DISCARD Service"	>> $RESULT_FILE
		serviceDISCARD=1
	else
		echo "Activate DISCARD Service" >> $RESULT_FILE
		serviceDISCARD=0
	fi
else
	serviceDISCARD=1
	echo "Not installed DISCARD Service" >> $RESULT_FILE
fi


echo "3. daytime 서비스" >> $RESULT_FILE
serviceDAYTIME=0
servicePath=`find /etc/xinetd.d/ -name 'daytime'`
if [ "$servicePath" != "" ]; then
	serviceSetting=`cat $servicePath | grep -i 'disable' | grep -i 'yes'`
	if [ "$serviceSetting" != "" ]; then
		echo "Disable DAYTIME Service"	>> $RESULT_FILE
		serviceDAYTIME=1
	else
		echo "Activate DAYTIME Service" >> $RESULT_FILE
		serviceDAYTIME=0
	fi
else
	serviceDAYTIME=1
	echo "Not installed DAYTIME Service" >> $RESULT_FILE
fi


echo "4. chargen 서비스" >> $RESULT_FILE
serviceCHARGEN=0
servicePath=`find /etc/xinetd.d/ -name 'chargen'`
if [ "$servicePath" != "" ]; then
	serviceSetting=`cat $servicePath | grep -i 'disable' | grep -i 'yes'`
	if [ "$serviceSetting" != "" ]; then
		echo "Disable CHARGEN Service"	>> $RESULT_FILE
		serviceCHARGEN=1
	else
		echo "Activate CHARGEN Service" >> $RESULT_FILE
		serviceCHARGEN=0
	fi
else
	serviceCHARGEN=1
	echo "Not installed CHARGEN Service" >> $RESULT_FILE
fi

if [ $serviceECHO -eq 1 ] && [ $serviceDISCARD -eq 1 ] && [ $serviceDAYTIME -eq 1 ] && [ $serviceCHARGEN -eq 1 ]; then
	echo "[U-23] 양호" >> $RESULT_FILE
else
	echo "[U-23] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset serviceECHO
unset serviceDISCARD
unset serviceDAYTIME
unset serviceCHARGEN
unset servicePath
unset serviceSetting
echo "[U-23] end"


echo "[U-24] start"
echo "[U-24] NFS 서비스 비활성화" >> $RESULT_FILE

nfs=`ps -ef | grep "nfs" | grep -v "grep nfs"`
echo $nfs >> $RESULT_FILE

if [ "$nfs" == "" ]; then
	echo "Disabled NFS Service" >> $RESULT_FILE
	echo "[U-24] 양호" >> $RESULT_FILE
else
	echo "Activate NFS Service" >> $RESULT_FILE
	echo "[U-24] 취약" >> $RESULT_FILE
fi

echo $splitLine >> $RESULT_FILE
unset nfs
echo "[U-24] end"


echo "[U-25] start"
echo "[U-25] NFS 접근 통제" >> $RESULT_FILE 2>&1

echo "/etc/exports 파일 출력" >> $RESULT_FILE 2>&1
echo `cat /etc/exports` >> $RESULT_FILE 2>&1
echo "불필요한 NFS 서비스를 사용하지 않거나, 사용 시에 everyone 공유를 제한한 경우 양호" >> $RESULT_FILE 2>&1
echo "1. 인터뷰를 통해 NFS 서비스 사용 이유 확인" >> $RESULT_FILE 2>&1
echo "2. 불필요한 NFS 서비스는 중지하고, 불가피하게 사용 시 everyone 공유 제거" >> $RESULT_FILE 2>&1
echo "[U-25] 인터뷰 필요" >> $RESULT_FILE 2>&1

echo "[U-25] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-26] start"
echo "[U-26] automountd 제거" >> $RESULT_FILE 2>&1

autofs_status_cmd=`service autofs status`

if [[ $autofs_status_cmd =~ 'running' ]]; then
    echo '[U-26] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-26] 양호' >> $RESULT_FILE 2>&1
fi

unset autofs_status_cmd
echo "[U-26] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-27] start"
echo "[U-27] RPC 서비스 확인" >> $RESULT_FILE 2>&1

echo "xinetd 파일 목록 출력" >> $RESULT_FILE 2>&1
find /etc/xinetd.d/ >> $RESULT_FILE 2>&1
echo "불필요한 서비스가 비활성화 되어 있는 경우 양호" >> $RESULT_FILE 2>&1
echo "1. 인터뷰를 통해 불필요한 RPC 서비스 존재 확인" >> $RESULT_FILE 2>&1
echo "2. 불필요한 RPC 서비스 비활성화 후 서비스 재시작" >> $RESULT_FILE 2>&1

echo "[U-27] 인터뷰 필요" >> $RESULT_FILE 2>&1
echo "[U-27] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-28] start"
echo "[U-28] NIS, NIS+ 점검" >> $RESULT_FILE 2>&1

ypserv_status_cmd=`/etc/rc.d/init.d/ypserv status`
ypbind_status_cmd=`/etc/rc.d/init.d/ypbind status`
ypxfrd_status_cmd=`/etc/rc.d/init.d/ypxfrd status`
yppasswdd_status_cmd=`/etc/rc.d/init.d/yppasswdd status`

if [[ $ypserv_status_cmd =~ 'running' ]] || [[ $ypbind_status_cmd =~ 'running' ]] || [[ $ypxfrd =~ 'running' ]] || [[ $yppasswdd =~ 'running' ]]; then
    echo '[U-28] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-28] 양호' >> $RESULT_FILE 2>&1
fi

unset ypserv_status_cmd
unset ypbind_status_cmd
unset ypxfrd_status_cmd
unset yppasswdd_status_cmd
echo "[U-28] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-29] start"
echo "[U-29] tftp, talk 서비스 비활성화" >> $RESULT_FILE 2>&1

tftp_disable_cmd=`cat /etc/xinetd.d/tftp | grep disable | cut -d' ' -f2`
talk_disable_cmd=`cat /etc/xinetd.d/talk | grep disable | cut -d' ' -f2`
ntalk_disable_cmd=`cat /etc/xinetd.d/ntalk | grep disable | cut -d' ' -f2`

if [[ $tftp_disable_cmd == 'no' ]] || [[ $talk_disable_cmd == 'no' ]] || [[ $ntalk_disable_cmd == 'no' ]]; then
    echo '[U-29] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-29] 양호' >> $RESULT_FILE 2>&1
fi

unset tftp_disable_cmd
unset talk_disable_cmd
unset ntalk_disable_cmd
echo "[U-29] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-30] start"
echo "[U-30] Sendmail 버전 점검" >> $RESULT_FILE 2>&1

echo "현재 사용 중인 Sendmail 버전" >> $RESULT_FILE 2>&1
echo 'version: '`rpm -q sendmail` >> $RESULT_FILE 2>&1
echo "Sendmail 버전이 최신 버전인 경우 양호" >> $RESULT_FILE 2>&1
echo "1. 인터뷰를 통해 Sendmail 버전 확인" >> $RESULT_FILE 2>&1
echo "2. 최신 버전으로 업데이트" >> $RESULT_FILE 2>&1

echo "[U-30] 인터뷰 필요" >> $RESULT_FILE 2>&1
echo "[U-30] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-31] start"
echo "[U-31] 스팸 메일 릴레이 제한" >> $RESULT_FILE 2>&1

sendmail_status_check_cmd=`service sendmail status | grep sendmail`
relay_check_cmd=`cat /etc/mail/sendmail.cf | grep -i "R$\*" | grep -i "relaying denied"`
relay_comment_check_cmd=`echo ${relay_check_cmd:0:1}`
result=0

if [[ $sendmail_status_check_cmd =~ 'stopped' ]]; then
    echo 'SMTP(sendmail) 서비스가 비활성화 중입니다. SMTP(sendmail) is stopped.' >> $RESULT_FILE 2>&1
    result=1
else
    echo 'SMTP(sendmail) 서비스가 활성화 중입니다. SMTP(sendmail) is running.' >> $RESULT_FILE 2>&1
    echo "릴레이 제한이 설정되어 있는 지 출력" >> $RESULT_FILE 2>&1

    if [[ $relay_comment_check_cmd != '#' ]]; then
        echo "릴레이 제한 설정 적용 중입니다. " >> $RESULT_FILE 2>&1
	result=1
    else
        echo "릴레이 제한 설정 미적용 중입니다." >> $RESULT_FILE 2>&1
	echo "릴레이 제한 설정이 적용되어 있는 경우 양호" >> $RESULT_FILE 2>&1
	echo "1. 인터뷰를 통해 릴레이 제한 설정이 적용 중인 지 확인" >> $RESULT_FILE 2>&1
    fi
fi

if [[ $result -eq 1 ]]; then
    echo "[U-31] 양호" >> $RESULT_FILE 2>&1
else
    echo "[U-31] 인터뷰 필요" >> $RESULT_FILE 2>&1
fi
unset sendmail_status_check_cmd
unset relay_check_cmd
unset relay_comment_check_cmd
unset result
echo "[U-31] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-32] start"
echo "[U-32] 일반사용자의 Sendmail 실행 방지" >> $RESULT_FILE 2>&1

sendmail_status_cmd=`service sendmail status`
restrictqrun_checking_cmd=`cat /etc/mail/sendmail.cf | grep -i privacyoptions | grep -i restrictqrun`

if [[ $sendmail_status_cmd =~ 'running' ]] && [[ -z "$restrictqrun_checking_cmd" ]]; then
    echo '[U-32] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-32] 양호' >> $RESULT_FILE 2>&1
fi

unset sendmail_status_cmd
unset restrictqrun_checking_cmd
echo "[U-32] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-33] start"
echo "[U-33] DNS 보안 버전 패치" >> $RESULT_FILE 2>&1

dns_status_cmd=`ps -ef | grep named | grep -v "grep"`
result=0

if [[ -z "$dns_status_cmd" ]]; then
    echo 'DNS 서비스가 비활성화 중입니다. named is stopped.' >> $RESULT_FILE 2>&1
    result=1
else
    echo "DNS 서비스 실행 여부 확인과 버전 확인" >> $RESULT_FILE 2>&1
    echo 'DNS 서비스가 활성화 중입니다. named is running.' >> $RESULT_FILE 2<&1
    echo 'version: '`rpm -q bind` >> $RESULT_FILE 2>&1

    echo "DNS 서비스를 주기적으로 패치를 관리하고 있을 시 양호" >> $RESULT_FILE 2<&1
    echo "1. 인터뷰를 통해 DNS 서비스의 주기적인 패치 여부 확인" >> $RESULT_FILE 2>&1
fi

if [[ $result -eq 1 ]]; then
    echo "[U-33] 양호" >> $RESULT_FILE 2>&1
else
    echo "[U-33] 인터뷰 필요" >> $RESULT_FILE 2>&1
fi

unset dns_status_cmd
unset result
echo "[U-33] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-34] start"
echo "[U-34] DNS Zone Transfer 설정" >> $RESULT_FILE 2>&1

dns_status_cmd=`ps -ef | grep named | grep -v "grep"`
allow_transfer_cmd=`cat /etc/named.conf | grep -i "allow-transfer"`
xfrnets_cmd=`cat /etc/named.conf | grep -i xfrnets`


if [[ $dns_status_cmd =~ 'named' ]]; then
    if [[ -z "$allow_transfer_cmd" ]] && [[ -z "$xfrnets_cmd" ]]; then
	echo '[U-34] 취약' >> $RESULT_FILE 2>&1
    else
	echo '[U-34] 양호' >> $RESULT_FILE 2>&1
    fi
else
	echo '[U-34] 양호' >> $RESULT_FILE 2>&1
fi

unset dns_status_cmd
unset allow_transfer_cmd
unset xfrnets_cmd
echo "[U-34] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-35] start"
echo "[U-35] Apache 디렉토리 리스팅 제거" >> $RESULT_FILE 2>&1

result=0
while read line
do
    var=`echo $line | cut -d' ' -f1 | tr [a-z] [A-Z]`

    if [[ $var == 'OPTIONS' ]]; then
        var=`echo $line | grep -i indexes | tr [a-z] [A-Z]`

   	if [[ $var =~ 'INDEXES' ]]; then
            result=$((result+1))
	fi
    fi
done < /etc/httpd/conf/httpd.conf	
if [[ $result -ge 1 ]]; then
    echo '[U-35] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-35] 양호' >> $RESULT_FILE 2>&1
fi

unset result
unset line
unset var
echo "[U-35] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-36] start"
echo "[U-36] Apache 웹 프로세스 권한 제한" >> $RESULT_FILE 2>&1

result=0
while read line
do
    var=`echo $line | cut -d' ' -f1 | tr [a-z] [A-Z]`

    if [[ $var == 'USER' ]] || [[ $var == 'GROUP' ]]; then
        var=`echo $line | cut -d' ' -f2`

   	if [[ $var == 'root' ]]; then
            result=$((result+1))
	fi
    fi
done < /etc/httpd/conf/httpd.conf	
if [[ $result -ge 1 ]]; then
    echo '[U-36] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-36] 양호' >> $RESULT_FILE 2>&1
fi

unset result
unset line
unset var
echo "[U-36] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-37] start"
echo "[U-37] Apache 상위 디렉토리 접근 금지" >> $RESULT_FILE 2>&1

result=0
while read line
do
    var=`echo $line | cut -d' ' -f1 | tr [a-z] [A-Z]`

    if [[ $var == 'ALLOWOVERRIDE' ]]; then
        var=`echo $line | grep -i allowoverride | tr [a-z] [A-Z]`

   	if [[ $var =~ 'NONE' ]]; then
            result=$((result+1))
	fi
    fi
done < /etc/httpd/conf/httpd.conf	
if [[ $result -ge 1 ]]; then
    echo '[U-37] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-37] 양호' >> $RESULT_FILE 2>&1
fi

unset result
unset line
unset var
echo "[U-37] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-38] start"
echo "[U-38] Apache 불필요한 파일 제거" >> $RESULT_FILE 2>&1
if test -f /etc/httpd/htdocs/manual || test -f /etc/httpd/manual; then
    result=$((result+1))
fi

if [[ $result -ge 1 ]]; then
    echo '[U-38] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-38] 양호' >> $RESULT_FILE 2>&1
fi

unset line
unset result
echo "[U-38] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-39] start"
echo "[U-39] Apache 링크 사용금지" >> $RESULT_FILE 2>&1

result=0
while read line
do
    var=`echo $line | cut -d' ' -f1 | tr [a-z] [A-Z]`

    if [[ $var == 'OPTIONS' ]]; then
        var=`echo $line | grep -i followsymlinks | tr [a-z] [A-Z]`

   	if [[ $var =~ 'FOLLOWSYMLINKS' ]]; then
            result=$((result+1))
	fi
    fi
done < /etc/httpd/conf/httpd.conf	
if [[ $result -ge 1 ]]; then
    echo '[U-39] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-39] 양호' >> $RESULT_FILE 2>&1
fi

unset result
unset line
unset var
echo "[U-39] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-40] start"
echo "[U-40] Apache 파일 업로드 및 다운로드 제한" >> $RESULT_FILE 2>&1

result=0
while read line
do
    var=`echo $line | cut -d' ' -f1 | tr [a-z] [A-Z]`

    if [[ $var == 'LIMITREQUESTBODY' ]]; then
        var=`echo $line | cut -d' ' -f2`

   	if [[ $var -gt 5000000 ]]; then
            result=$((result+1))
	fi
    else
	result=$((result+1))
    fi
done < /etc/httpd/conf/httpd.conf	
if [[ $result -ge 1 ]]; then
    echo '[U-40] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-40] 양호' >> $RESULT_FILE 2>&1
fi

unset result
unset line
unset var
echo "[U-40] end"
echo $splitLine >> $RESULT_FILE 2>&1

DEFAULT_PATH001='"/usr/local/apache/htdocs"'
DEFAULT_PATH002='"/usr/local/apache2/htdocs"'
DEFAULT_PATH003='"/var/www/html"'

result=0
echo "[U-41] start"
echo "[U-41] Apache 웹 서비스 영역의 분리" >> $RESULT_FILE 2>&1
while read line
do
    var=`echo $line | cut -d' ' -f1 | tr [a-z] [A-Z]`
    
    if [[ $var == 'DOCUMENTROOT' ]]; then
        var=`echo $line | cut -d' ' -f2`
	
	if [[ $var == $DEFAULT_PATH001 ]] || [[ $var == $DEFAULT_PATH002 ]] || [[ $var == $DEFAULT_PATH003 ]]; then
	    result=$((result+1))
	fi
    fi
done < /etc/httpd/conf/httpd.conf
if [[ $result -ge 1 ]]; then
    echo '[U-41] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-41] 양호' >> $RESULT_FILE 2>&1
fi

unset line
unset var
unset result
unset DEFAULT_PATH001
unset DEFAULT_PATH002
unset DEFAULT_PATH003
echo "[U-41] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-42] start"
echo "[U-42] 최신 보안패치 및 벤더 권고사항 적용" >> $RESULT_FILE 2>&1

echo "패치 적용 정책을 수립하여 주기적으로 패치관리를 하고 있으며, 패치 관련 내용을 확인하고 적용했을 경우 양호" >> $RESULT_FILE 2>&1
echo "1. 인터뷰를 통해 패치 적용 정책을 수립하여 주기적으로 패치관리를 하며, 패치 관련 내용을 확인하고 적용 중인 지 확인" >> $RESULT_FILE 2>&1

echo "[U-42] 인터뷰 필요" >> $RESULT_FILE 2>&1
echo "[U-42] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-43] start"
echo "[U-43] 로그의 정기적 검토 및 보고" >> $RESULT_FILE 2>&1

echo "접속 기록 등의 보안 로그, 응용 프로그램 및 시스템 로그 기록에 대해 정기적으로 검토, 분석, 리포트 작성 및 보고 등의 조치가 이루어 지고 있을 시 양호" >> $RESULT_FILE 2>&1
echo "1. 인터뷰를 통해 접속기록 등의 보안 로그. 응용 프로그램 및 시스템 로그 기록에 대해 정기적으로 검토, 분석, 리포트 작성 및 보고 등의 조치가 이루어 지는 지 확인" >> $RESULT_FILE 2>&1

echo "[U-43] 인터뷰 필요" >> $RESULT_FILE 2>&1
echo "[U-43] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-44] start"
echo "[U-44] root 이외의 UID가 '0' 금지'" >> $RESULT_FILE 2>&1
while read line
do
    var=`echo $line | cut -d':' -f1`
    
    if [[ $var != 'root' ]]; then
        var=`echo $line | cut -d':' -f3`
	
	if [[ $var == '0' ]]; then
	    result=1
	else
	    result=0
	fi
    fi
done < /etc/passwd

if [[ $result -eq 1 ]]; then
    echo '[U-44] 취약' >> $RESULT_FILE 2>&1
else
    echo '[U-44] 양호' >> $RESULT_FILE 2>&1
fi

unset line
unset var
unset result
echo "[U-44] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-45] start"
echo "[U-45] root 계정 su 제한" >> $RESULT_FILE 2>&1

wheel_group_check_cmd=`cat /etc/group | grep wheel | cut -d':' -f4`

echo -e "/etc/group 'wheel' 그룹 사용자 출력" >> $RESULT_FILE 2>&1
echo '>> 사용자 목록: '$wheel_group_check_cmd >> $RESULT_FILE 2>&1
echo "su 명령어를 특정 사용자에게만 허용하였을 시 양호" >> $RESULT_FILE 2>&1
echo "1. 인터뷰를 통해 /etc/group 'wheel' 그룹에 특정 사용자만 추가하였는 지 확인" >> $RESULT_FILE 2>&1

echo "[U-45] 인터뷰 필요" >> $RESULT_FILE 2>&1

unset wheel_group_check_cmd
echo "[U-45] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-46] start"
echo "[U-46] 패스워드 최소 길이 설정" >> $RESULT_FILE 2>&1
while read line
do
    var=`echo $line | cut -d' ' -f1`
        if [[ $var =~ 'PASS_MIN_LEN' ]]; then
    	    var=`echo $line | cut -d' ' -f2`
            if [[ $var -ge 8 ]]; then
		result=1
	    else
		result=0
	    fi
        fi
done < /etc/login.defs

if [[ $result -eq 1 ]]; then
    echo '[U-46] 양호' >> $RESULT_FILE 2>&1
else
    echo '[U-46] 취약' >> $RESULT_FILE 2>&1
fi

unset line
unset var
unset result
echo "[U-46] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-47] start"
echo "[U-47] 패스워드 최대 사용기간  설정" >> $RESULT_FILE 2>&1
while read line
do
    var=`echo $line | cut -d' ' -f1`
        if [[ $var =~ 'PASS_MAX_DAYS' ]]; then
    	    var=`echo $line | cut -d' ' -f2`
            if [[ $var -ge 90 ]]; then
		result=1
	    else
		result=0
	    fi
        fi
done < /etc/login.defs

if [[ $result -eq 1 ]]; then
    echo '[U-47] 양호' >> $RESULT_FILE 2>&1
else
    echo '[U-47] 취약' >> $RESULT_FILE 2>&1
fi

unset line
unset var
unset result
echo "[U-47] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-48] start"
echo "[U-48] 패스워드 최소 사용기간  설정" >> $RESULT_FILE 2>&1
while read line
do
    var=`echo $line | cut -d' ' -f1`
        if [[ $var =~ 'PASS_MIN_DAYS' ]]; then
    	    var=`echo $line | cut -d' ' -f2`
            if [[ $var -ge 1 ]]; then
		result=1
	    else
		result=0
	    fi
        fi
done < /etc/login.defs

if [[ $result -eq 1 ]]; then
    echo '[U-48] 양호' >> $RESULT_FILE 2>&1
else
    echo '[U-48] 취약' >> $RESULT_FILE 2>&1
fi

unset line
unset var
unset result
echo "[U-48] end"
echo $splitLine >> $RESULT_FILE 2>&1


echo "[U-49] start"
echo "[u-49] 불필요한 계정 제거"        >> $RESULT_FILE 2>&1
TARGET1=/etc/passwd
CHECK1=$(awk -F: '{print $1}' $TARGET1 | egrep 'lp|uucp|nuucp')
if [[ -z $CHECK1 ]]; then
    echo "[U-49] 양호 \nlp, uucp, nuucp 계정이 존재하지 않습니다."       >> $RESULT_FILE 2>&1
else
    echo "[U-49] 취약\n- 아래 불필요한 계정 삭제(userdel -r 계정명)\n$CHECK1"        >> $RESULT_FILE 2>&1

fi
unset CHECK1
unset TARGET1
echo "[U-49] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-50] start"
echo "[U-50] 관리자 그룹에 최소한의 계정 포함"        >> $RESULT_FILE 2>&1
TARGET1=/etc/group
echo "[U-50] 인터뷰 필요"       >> $RESULT_FILE 2>&1
echo "[U-50] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-51] start"
echo "[U-51] 계정이 존재하지 않는 GID 금지"        >> $RESULT_FILE 2>&1
TARGET1=/etc/group
TARGET2=/etc/gshadow
echo "[U-51] 인터뷰 필요"       >> $RESULT_FILE 2>&1
echo "[U-51] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-52] start"
echo "[U-52] 동일한 UID 금지"        >> $RESULT_FILE 2>&1
cat /etc/passwd |awk -F: '{print $3}' > tmp.log
cat tmp.log |uniq >tmp2.log
diff tmp.log tmp2.log >> /dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "[U-52] 양호 동일한 UID로 설정된 사용자 계정이 존재하지 않습니다."    >> $RESULT_FILE 2>&1
else
        echo "[U-52] 취약 UID로 설정된 사용자 계정이 존재합니다"  >> $RESULT_FILE 2>&1
fi
rm tmp.log tmp2.log
echo "[U-52] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-53] start"
echo "[U-53] 사용자 shell 점검" >> $RESULT_FILE 2>&1
TARGET1=/etc/passwd
CHECK1=$(cat $TARGET1 | egrep -v '/bin/false|/sbin/nologin')    >> $RESULT_FILE 2>&1
echo "[U-53] 수동 (로그인 불필요 계정 셸 변경(usermod -s /bin/false 계정명))\n$CHECK1"    >> $RESULT_FILE 2>&1
echo "[U-53] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-54] start"
echo "[U-54] Session Timeout 설정"              >> $RESULT_FILE 2>&1
TARGET1=/etc/profile
if [[ -e $TARGET1 ]]; then
    CHECK1=$(grep 'TMOUT=600' $TARGET1 | grep -v '#')
    if [[ -n $CHECK1 ]]; then
        echo "[U-54] 양호 \n$CHECK1 설정 확인"              >> $RESULT_FILE 2>&1
    else
        echo "[U-54] 취약 \n- 아래 내용 추가 시 양호\nexport TMOUT=600"             >> $RESULT_FILE 2>&1
    fi
else
        echo "[U-54] 취약 \n$TARGET1 파일 없음"             >> $RESULT_FILE 2>&1
fi
echo "[U-54] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-55] start"
echo "[U-55] hosts.lpd 파일 소유자 및 권한 설정" >> $RESULT_FILE 2>&1
TARGET1=/etc/host.ipd

if [ -f $TARGET1 ] ; then
        RUSER=`ls -l $TARGET1 | awk '{print $3}'`
        WRITE=`ls -l $TARGET1 | cut -c 9`
        if [ $RUSER == 'root' ] && [ $WRITE == '-' ] ; then
                echo "[U-55] 양호 $TARGET1 소유자가 관리자 입니다."     >> $RESULT_FILE 2>&1
        else
                ls -l $TARGET1 >> $LOG
        if [ $RUSER != 'root' ] ; then
                echo "[U-55] 취약 $TARGET1 소유자가 관리자가 아닙니다." >> $RESULT_FILE 2>&1
        fi

        if [ $WRITE == 'w' ] ; then
                echo "[U-55] 취약 $TARGET1 퍼미션 설정이 잘 못 되었습니다."     >> $RESULT_FILE 2>&1
        fi
        fi
else
        echo "[U-55] 취약 프린터를 사용하고 있지 않습니다."    >> $RESULT_FILE 2>&1
fi
echo "[U-55] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-56] start"
echo "[U-56] 사용자 shell 점검" >> $RESULT_FILE 2>&1
LOG=log.txt
ps -ef | grep ypserv | grep -v grep > $LOG
if [ -s $LOG ] ; then
        echo "[U-56] 취약 NIS 서비스를 사용 중 입니다."    >> $RESULT_FILE 2>&1
else
        echo "[U-56] 양호 NIS 서비스를 사용하고 있지 않습니다."    >> $RESULT_FILE 2>&1
fi
echo "[U-56] end"
rm $LOG
echo $splitLine >> $RESULT_FILE 2>&1


echo "[U-57] start"
echo "[U-57] UMASK 설정 관리"           >> $RESULT_FILE 2>&1
CHECK1=$(egrep 'umask 022|umask 027' /etc/profile /etc/bashrc | wc -l)
if [[ 2 -eq $CHECK1 ]]; then
    echo "[U-57] 양호 \n/etc/profile, /etc/bashrc 파일에 umask 022 설정 확인"               >> $RESULT_FILE 2>&1
else
    echo "[U-57] 취약 \n/etc/profile, /etc/bashrc 파일에 umask 022 설정 시 양호"            >> $RESULT_FILE 2>&1
fi
echo "[U-57] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-58] start"
echo "[U-58] 홈디렉토리 소유자 및 권한 설정"    >> $RESULT_FILE 2>&1
CHECK1=`cat /etc/passwd | grep root | sed -n '1p' | awk -F: '{print$6}' | ls -l /../ | awk '{print $1$8}' | grep root | awk -F. '{print $1}'`
RDP=dr-xr-x--- 

if test $CHECK1=$RDP
	then
		echo "[U-58] 양호 root 홈 디렉터리 권한 : " $CHECK1   >> $RESULT_FILE 2>&1
	else
		echo "[U-58] 취약 root 홈 권한 : " $CHECK1    >> $RESULT_FILE 2>&1
fi
echo "[U-58] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-59] start"
echo "[U-59] 홈 디렉토리로 지정한 디렉토리의 존재 관리"    >> $RESULT_FILE 2>&1
TARGET1=/etc/passwd
cat $TARGET1 | awk -F: '{print $1,$6}' >> W-59.log
echo "[U-59] 인터뷰 필요"       >> $RESULT_FILE 2>&1
echo "[U-59] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-60] start"
echo "[U-60] 숨겨진 파일 및 디렉토리 검색 및 제거"    >> $RESULT_FILE 2>&1
# find / -name ‘.*’ >> W-60.log
echo "[U-60] 인터뷰 필요"       >> $RESULT_FILE 2>&1
echo "[U-60] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-61] start"
echo "[U-61] ssh 원격접속 허용"    >> $RESULT_FILE 2>&1
ps -ef | grep sshd | grep -v grep > tmp.log
if [ -s tmp.log ] ; then
        echo "[U-61] 양호 ssh 서비스를 사용 중입니다."       >> $RESULT_FILE 2>&1
else 
        echo "[U-61] 취약 ssh 서비스를 사용하고 있지 않습니다."       >> $RESULT_FILE 2>&1
fi
rm tmp.log
echo "[U-61] end"
echo $splitLine >> $RESULT_FILE 2>&1


echo "[U-62] start"
echo "[U-62] FTP 서비스 확인"       >> $RESULT_FILE 2>&1
CHECK1=$(ps -ef | grep ftp)
CHECK2=$(ps -ef | egrep "vsftpd|proftp")
if [[ -n $CHECK1 ]]; then
    if [[ -z $CHECK2 ]]; then
            echo "[U-62] 양호 ftp 서비스 중지 상태"    >> $RESULT_FILE 2>&1
    else
            echo "[U-62] 취약 ftp 서비스 실행 상태"    >> $RESULT_FILE 2>&1
    fi
fi
unset CHECK1
unset CHECK2
echo "[U-62] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-63] start"
echo "[U-63] ftp 계정 shell 제한"       >> $RESULT_FILE 2>&1
cat /etc/passwd | grep ftp >> tmp.log
CHECK=`cat tmp.log | awk -F: '{print $NF}' | awk -F/ '{print $NF}'`
if [ $CHECK == 'nologin' ] || [ $CHECK == 'false' ] ; then
        echo "[U-63] 양호 ftp 계정에 쉘이 부여되어 있지 않습니다."    >> $RESULT_FILE 2>&1
else
        echo "[U-63] 취약 ftp 계정에 $CHECK 쉘이 부여되어 있습니다."    >> $RESULT_FILE 2>&1
fi
rm tmp.log
echo "[U-63] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-64] start"
echo "[U-64] ftpusers 파일 소유자 및 권한 설정"       >> $RESULT_FILE 2>&1
TARGET1=/etc/vsftpd/ftpusers
ROOT=`ls -l $TARGET1 | awk '{print $3}'`
if [ "$ROOT" == 'root' ] ; then
        echo "[U-64] 양호 $TARGET1 소유자가 root로 설정되어 있습니다."    >> $RESULT_FILE 2>&1
else
        echo "[U-64] 취약 $TARGET1 소유자가 root로 설정되어 있지 않습니다."    >> $RESULT_FILE 2>&1
fi

CHECK=`ls -l $TARGET1 | awk '{print $1}' | cut -c 2-`
find $TARGET1 -perm -640 -ls | grep -v 'rw-r-----' >> W-62.log

if [ -s W-62.log ] ; then
        echo "[U-64] 취약 $TARGET1 권한 설정을 다시하세요."    >> $RESULT_FILE 2>&1
else
        echo "[U-64] 양호 권한 설정이 올바르게 되어있습니다."    >> $RESULT_FILE 2>&1
fi
echo "[U-64] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-65] start"
echo "[U-65] ftp 계정 shell 제한"       >> $RESULT_FILE 2>&1
TARGET1=/etc/vsftpd/ftpusers
ps -ef | grep vsftpd | grep -v grep >> tmp.log
if [ -s tmp.log ] ; then
        echo "[U-65] 양호 ftp 서비스가 활성화되어 있습니다."    >> $RESULT_FILE 2>&1
else
        echo "[U-65] 취약 ftp 서비스가 비활성화되어 있습니다."    >> $RESULT_FILE 2>&1
fi

cat $TARGET1 | grep 'root' | grep -v '#' >/dev/null
if [ $? -eq 0 ] ; then
        echo "[U-65] 취약 root 계정 접속을 허용합니다."    >> $RESULT_FILE 2>&1
else
        echo "[U-65] 양호 root 계정 접속을 차단합니다."    >> $RESULT_FILE 2>&1
fi
rm tmp.log
echo "[U-65] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-66] start"
echo "[U-66] at 파일 소유자 및 권한 설정"       >> $RESULT_FILE 2>&1
cat << EOF >> tmp.log
/etc/at.deny
/etc/at.allow
EOF
cat tmp.log | while read VAR1
do
if [ -f $VAR1 ] ; then
        ROOT=`ls -l $VAR1 | awk '{print $3}'`
        if [ $ROOT == 'root' ] ; then
                echo "[U-66] 양호 $VAR1의 소유자가 root로 설정되어 있습니다."    >> $RESULT_FILE 2>&1
        else
                echo "[U-66] 취약 $VAR1의 소유자가 root로 설정되어 있지 않습니다."    >> $RESULT_FILE 2>&1

fi

CHECK=`ls -l $VAR1 | awk '{print $1}' | cut -c 2-`
find $VAR1 -perm -640 -ls | grep -v 'rw-r-----' > W-66.log

if [ -s W-64.log ] ; then
        echo "[U-66] 취약 $VAR1의 권한 설정을 다시하세요."    >> $RESULT_FILE 2>&1
else
        echo "[U-66] 양호 권한 설정이 올바르게 되어있습니다."    >> $RESULT_FILE 2>&1
fi
fi
done
rm tmp.log
echo "[U-66] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-67, 68] start"
echo "[U-67, 68] SNMP 서비스 구동 점검"     >> $RESULT_FILE 2>&1

TARGET1=/etc/snmp/snmpd.conf
CHECK1=$(ps -ef | grep snmp | grep -v pts)
if [[ -n $CHECK1 ]]; then
        CHECK2=$(egrep 'public|private' $TARGET1 | grep -v '#' | grep -v pts)       
        if [[ -e $TARGET1 ]]; then
                if [[ -z $CHECK2 ]];then
                        echo "[U-67, 68] 양호 \nsnmpd 서비스 실행 상태\npublic, private community 없음"      >> $RESULT_FILE 2>&1
                else
                        echo "[U-67, 68] 취약 \nsnmpd 서비스 실행 상태\npublic, private community 제거 시 양호"      >> $RESULT_FILE 2>&1
                fi
        else
                echo "[U-67, 68] 점검 \nsnmpd 서비스 실행 상태\n/etc/snmp/snmpd.conf 파일 없음"      >> $RESULT_FILE 2>&1
        fi
else
        echo "[U-67, 68] 양호 \nsnmpd 서비스 중지 상태"      >> $RESULT_FILE 2>&1
fi
echo "[U-67, 68] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-69] start"
echo "[U-69] 로그온 시 경고 메시지 제공"    >> $RESULT_FILE 2>&1
TARGET1=/etc/issue.net
cat $TARGET1 >> W-67.log
echo "[U-69] 인터뷰 필요"       >> $RESULT_FILE 2>&1
echo "[U-69] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-70] start"
echo "[U-70] NFS 설정파일 접근권한"    >> $RESULT_FILE 2>&1
CHECK1=`ls -al /etc/exports | grep root | sed -n '1p' | awk -F: '{print$6}' | ls -l /../ | awk '{print $1$8}' | grep root | awk -F. '{print $1}'`
RDP=drw-r--r-- 
if test $CHECK1=$RDP
	then
		echo "[U-70] 양호 NFS 접근제어 권한 : " $CHECK1   >> $RESULT_FILE 2>&1
	else
		echo "[U-70] 취약 NFS 접근제어 권한 : " $CHECK1    >> $RESULT_FILE 2>&1
fi
echo "[U-70] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-71] start"
echo "[U-71] expn, vrfy 명령어 제한"    >> $RESULT_FILE 2>&1
TARGET1=/etc/mail/sendmail.cf
cat << EOF >> W-71.log
novrfy
noexpn
EOF

ps -ef | grep sendmail | grep -v grep >> tmp.log
if [ -s tmp.log ] ; then
        echo "[U-71] 취약 SMTP 서비스를 사용하고 있습니다."       >> $RESULT_FILE 2>&1
else
        echo "[U-71] 양호 SMTP 서비스를 사용하고 있지 않습니다."       >> $RESULT_FILE 2>&1
fi
cat W-71.log | while read VAR1
do
cat $TARGET1 | grep PrivacyOptions | grep --color $VAR1 >/dev/null

if [ $? -eq 0 ] ; then
        echo "[U-71] 양호 $VAR1 옵션이 설정되어 있습니다."       >> $RESULT_FILE 2>&1
else
        echo "[U-71] 취약 $VAR1 옵션이 설정되어 있지 않습니다."       >> $RESULT_FILE 2>&1

fi
done
rm tmp.log
echo "[U-71] end"
echo $splitLine >> $RESULT_FILE 2>&1

echo "[U-72] start"
echo "[U-72] expn, vrfy 명령어 제한"    >> $RESULT_FILE 2>&1
TARGET1=/etc/httpd/conf/httpd.conf
cat $TARGET1 | grep -i servertokens >> W-72.log
cat W-72.log | while read VAR1
do
CHECK=`echo W-72.log | grep -i servertokens | awk '{print $2}'`

if [ '$CHECK' == 'Prod' ] ; then
	echo "[U-72] 양호 Prod 설정이 되어 있습니다."       >> $RESULT_FILE 2>&1
else
	echo "[U-72] 취약 Prod 설정이 되어있지 않습니다."       >> $RESULT_FILE 2>&1
fi
done
echo "[U-72] end"

rm W-59.log
rm W-62.log
rm W-66.log
rm W-67.log
rm W-71.log
rm W-72.log
rm nul






















