<################################################################################>
<##                                                                            ##>
<##                           DeleteHomeDirectory.PS1                          ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##                This script deletes the user's home folder.                 ##>
<##                                                                            ##>
<##               This script was created using POWERSHELL ISE                 ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>

#Assigning path a to a variable names Hdrive.

$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Disables"

#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\DeleteHomeDirectory\$date")
$Logfile = "$Hdrive\logs\$dateonly\DeleteHomeDirectory\$date\DeleteHomeDirectory.txt"

#Imports data file and sets a loop to run code on all specified users in data file.

import-Csv "$Hdrive\CSV\Purgeupdates.csv" | ForEach-Object {

#Deletes the folder from attributes set.

$Server = $_.ServerUNC
$Username = $_.name
$middle = 'e$\usr\'
$middle2 = 'f$\usr\'
if (test-path -isvalid "$Server$middle$username")
    {
    Remove-Item -Recurse -Force "$Server$middle$UserName" 
    "$Server$middle$UserName deleted" | out-file -append $logfile 
    } 
else 
    {
    Remove-Item -Recurse -Force "$Server$middle2$UserName"
    "$Server$middle2$UserName deleted" | out-file -append $logfile 
    } 
   
}
start notepad $logfile