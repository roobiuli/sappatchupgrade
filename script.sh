#!/bin/bash

# Purpose ( Upgrade sap application servers to patch level 18 )
# Author Robert Nicoara 

function upgrade_SP_LEVEL {

		 ssh ibmadmin@$H "sudo  /usr/sap/hostctrl/exe/saphostexec -upgrade -archive /home/ibmadmin/SAPHOSTAGENT18_18-20009394.SAR"

		 PATCHUPGR=`ssh ibmadmin@$H "sudo /usr/sap/hostctrl/exe/saphostexec -version | grep -i 'patch number'" |awk '{print $NF}'`

		 if [ $PATCHUPGR -eq 18 ]
		 	then
		 		echo " Yes $HNAME has the patch level at Version 18 "
		 	else
		 		echo " $HNAME : Upgrade was performed however still not at V 18 "
		 	fi
}


for H in `cat hosts.txt`
do
	PATCHNUM=`ssh ibmadmin@$H "sudo /usr/sap/hostctrl/exe/saphostexec -version | grep -i 'patch number'" | awk '{ print $NF }'`
	HNAME=`ssh ibmadmin@$H "sudo hostname"`
	if [ $PATCHNUM -lt 18 ]
		then

			echo "on $HNAME the PATCH level is $PATCHNUM ... UPGRADE NEEDED"
		elif [ $PATCHNUM -eq 18 ]
			then
			echo "on $HNAME the PATCH level is $PATCHNUM ... No upgrade needed"
		elif [ $PATCHNUM -gt 18 ]
			then
				echo "on $HNAME the PATCH level is $PATCHNUM ... WHOa... Inform PDL ASAP "

			fi

	done




