#####
The purpose of this script is to upgrade  the saphost patch level
--- Usage ---

Add the SAR file in the homedir 

Add a hosts.txt file and in that file each ip of the hosts where you need the upgrade ( one per line ) 

execute the script , it will ask you what patchlevel the SAR file is 
IF the patchlevel is less then what you provide it will auto push the sar to the server and perform the upgrade also at the end it will look if the SAPOSCOL proccess is still running 
it will inform you if it`s not 

Also if the patch level is equal or bigger then the one you provide it will inform you and it will do nothing 

