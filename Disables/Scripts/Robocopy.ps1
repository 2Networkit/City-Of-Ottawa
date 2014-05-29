<################################################################################>
<##                                                                            ##>
<##                                Robocopy.PS1                                ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##  This script copies data from home folder to the disabled folder keeping   ##>
<##                     keeping all rights and attributes.                     ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>

#Assigning path a to a variable names Hdrive.

$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Disables"

#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\Robocopy\$date")
$Logfile = "$Hdrive\logs\$dateonly\Robocopy\$date\Robocopy1.txt"
$Logfile1 = "$Hdrive\logs\$dateonly\Robocopy\$date\Robocopy.txt"
#Imports data file.

import-Csv "$Hdrive\CSV\updates.csv" | ForEach-Object {


#Displays the user on screen having a robocopy done. 

write-output "***Username: " $_.name
write-output "***Full Name: " $_.fullname 

#Command for copying the old location to new location and outputs info in log file.

ROBOCOPY $_.homefoldertobecopied $_.Disabledfolder /z /e /v /copyall /eta /r:1 /w:0 | out-file -append $logfile

}
#Opens TXT with notepad.
Get-Content $Logfile | Where-Object {$_ -notmatch '%'} | Set-Content $logfile1
remove-item $logfile
start notepad $Logfile1