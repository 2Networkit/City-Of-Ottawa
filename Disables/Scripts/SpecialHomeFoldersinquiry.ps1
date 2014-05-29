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
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Disables"


#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\SpecialHomefoldersInquiry\$date")
$Logfile = "$Hdrive\logs\$dateonly\SpecialHomefoldersInquiry\$date\SpecialHomefoldersInquiry.csv"
#Starts recording data to log file.





#Imports data file.
function Get-Size
{
 param([string]$pth)
 "{0:n2}" -f ((gci -path $pth -recurse | measure-object -property length -sum).sum /1mb) + " mb"
}
import-Csv "$Hdrive\csv\Purgeupdates.csv" | ForEach-Object {

$name = $_.SamaccountName
$Homefolder = (Get-Aduser $name -properties homedirectory).homedirectory
$State = (Get-Aduser $name -properties enabled).enabled 
$Size = Get-size $homefolder

$o = new-object PSObject
$o | add-member NoteProperty Name $Name
$o | add-member NoteProperty HomeDirectory $Homefolder
$o | add-member NoteProperty Size $size

#Checks if account is active or Disabled.
if ($State -eq $true)
    {
    $o | add-member NoteProperty State "Active"
    }
        Else
            {
            $o | add-member NoteProperty State "Disabled"
            }

$o | export-csv -append "$Logfile" -notypeinformation
}
start excel "$logfile"