#!/bin/bash

# Purpose ( Upgrade sap application servers to patch level 18 )
# Author Robert Nicoara 

echo "########################## ATENTION !!!! ##################"
echo "					----------			----	-----	-----"
echo "Please provide the PATCH NUMBER TARGET ex: 18 if PN is eq or less then PN it will upgrade /n
		PERFORM THE UPGRADE !!!!!!  NO SPACES ONLY TWO DIGIT NUMEBERS /n EX:18"

read VERS

function VERIFYPID {

	 ssh ibmadmin@$H "sudo ps aux | grep -i saposcol | grep -iv 'grep'" > /dev/null 2>&1

		if [ $? -eq 0 ]
			then
			echo "SAPOSCOL PID present after upgrade EVERYTHING COOL on $HNAME now"
		else
			echo "$HNAME UPGRADE PERFORME HOWEVER SAPOSCOL PID NOT PRESENT INFORM PDL ASAP "
		fi

}
function upgrade_SP_LEVEL {
		FILE=`ls *SAR`
		scp $FILE ibmadmin@$H:/home/ibmadmin

	 ssh ibmadmin@$H "sudo  /usr/sap/hostctrl/exe/saphostexec -upgrade -archive /home/ibmadmin/$FILE" > /dev/null 2>&1

		 PATCHUPGR=`ssh ibmadmin@$H "sudo /usr/sap/hostctrl/exe/saphostexec -version | grep -i 'patch number'" |awk '{print $NF}'`

		 if [ $PATCHUPGR -eq 18 ]
		 	then
		 		echo " Yes $HNAME has the patch level at Version 18 NOW "
		 	else
		 		echo " $HNAME : Upgrade was performed however still not at V 18 "
		 	fi
}


for H in `cat hosts.txt`
do
	PATCHNUM=`ssh ibmadmin@$H "sudo /usr/sap/hostctrl/exe/saphostexec -version | grep -i 'patch number'" | awk '{ print $NF }'`
	HNAME=`ssh ibmadmin@$H "sudo hostname"`
	if [ $PATCHNUM -lt $VERS ] || [ $PATCHNUM -eq 198 ] || [ $PATCHNUM -eq 205 ]
		then

			echo "on $HNAME the PATCH level is $PATCHNUM ... UPGRADE NEEDED... PROBING"
			upgrade_SP_LEVEL
			VERIFYPID

		elif [ $PATCHNUM -eq $VERS ]
			then
			echo "on $HNAME the PATCH level is $PATCHNUM ... No upgrade needed"
		elif [ $PATCHNUM -gt $VERS -a $PATCHNUM -ne 198 ] 
			then
				echo "on $HNAME the PATCH level is $PATCHNUM ... WHOa... Inform PDL ASAP "

			fi

	done




