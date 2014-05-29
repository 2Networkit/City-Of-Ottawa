<################################################################################>
<##                                                                            ##>
<##                               Homefolders.PS1                              ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##      This script opens user's AD record and pulls the Homefolder data.     ##>
<##                   It then checks that path for its size.                   ##>
<##                        It exports the data in a CSV file.                  ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>

#Assigning path a to a variable names Hdrive
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create"


#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\Homefolders\$date")
$Logfile = "$Hdrive\logs\$dateonly\Homefolders\$date\Homefolders.csv"
#Starts recording data to log file.


#Imports data file.

import-Csv "$Hdrive\csv\updates.csv" | ForEach-Object {

$name = $_.Clone
if (-not $name)
{
$o = new-object PSObject
$o | add-member NoteProperty Name ""
$o | add-member NoteProperty HomeDirectory ""
$o | export-csv -append "$Logfile" -notypeinformation


}
Else
{
$Homefolder = (Get-Aduser -identity $name -properties homedirectory).homedirectory 

$o = new-object PSObject
$o | add-member NoteProperty Name $Name
$o | add-member NoteProperty HomeDirectory $homefolder
$o | export-csv -append "$Logfile" -notypeinformation



}
}
start excel "$logfile"