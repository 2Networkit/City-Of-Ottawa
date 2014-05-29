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
Mkdir ($Hdrive+"\Logs\$dateonly\DailyReports\$date")
$reportFile = "$Hdrive\logs\$dateonly\DailyReports\$date\"
$Logfile = "$Hdrive\logs\$dateonly\Homefolders\$date\Homefolders.csv"
$Email = "$Hdrive\Email\CreateEmail1.txt"
#Starts recording data to log file.


#Imports data file and creates a log file with the H drive setting for the clone account. if there is no clone, it will leave the cell empty.

import-Csv "c:\temp\updates.csv" | ForEach-Object {

$name = $_.Clone
$User = $_.Username
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

#Creates link to Homefolder log in email file
        
"$logfile" | out-file -append $Email


#Opens the log file to show the data.
$content = Get-Content $Logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $Logfile
copy-item $logfile 'c:\temp\'
copy-item '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\DailyReports\New Accounts EDS.xlsx' $Reportfile
#start excel "$logfile"