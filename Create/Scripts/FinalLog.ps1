<################################################################################>
<##                                                                            ##>
<##                                FinalLog.PS1                                ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##        This script opens the user's AD record and pulls the credentials.   ##>
<##            It then outputs its Principal name, Home drive letter,          ##>
<##                    share and the script path in a CSV file.                ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>




#Assigning path a to a variable names Hdrive
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create"


#Assigns logdrive, date and format & logfile
$Date = get-date -f MM-dd-yyyy_HH-mm-ss
$Dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\FinalLogtest\$date")
$Logfile = "$Hdrive\logs\$dateonly\FinalLogtest\$date\FinalLogtest.txt"
$Email = "$Hdrive\Email\CreateEmail6.txt"
$Folders = Import-csv "$Hdrive\CSV\Updates.csv" 
$ErrorActionPreference= 'silentlycontinue'
import-module activedirectory



#Creates a logfile with AD credential for the new user.

ForEach ($Folder in $Folders) 
{ 
$user = $Folder.Username
"User: $User" | out-file -append $logfile
"`n" | out-file -append $logfile
"AD Credentials:" | out-file -append $logfile

Get-ADUser $user -properties * | FT  UserPrincipalName | out-file -append $logfile
Get-ADUser $user -properties * | FT  ScriptPath | out-file -append $logfile
Get-ADUser $user -properties * | FT  homedrive  | out-file -append $logfile
Get-ADUser $user -properties * | FT  HomeDirectory | out-file -append $logfile
Get-ADUser $user -properties * | FT  mail | out-file -append $logfile

"Groups set for $User" | out-file -append $logfile
Get-adprincipalgroupmembership $User | select name | out-file -append $logfile

"Exchange Credentials:" | out-file -append $logfile
Get-mailbox -identity $user | FL *customattribute* | out-file -append $logfile
Get-Mailbox -identity $User | FL *Quota* | out-file -append $logfile 
Get-Mailbox -identity $user | FL *GrantSendOnBehalfTo* | out-file -append $logfile 
Get-Mailbox -identity $user | FL *forward* | out-file -append $logfile
Get-Mailbox -identity $user | FL *ProcessExternalMeetingMessages* | out-file -append $logfile
Get-Mailbox -identity $User | List PrimarySmtpAddress, EmailAddresses | out-file -append $logfile




" _________________________________________________________________________________________________________" | out-file -append $logfile
"`n" | out-file -append $logfile
"`n" | out-file -append $logfile

}

#Creates link to FinalLog log in email file
     
"$logfile" | out-file -append $Email

#Opens the log file to show the data.
$content = Get-Content $Logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $Logfile
#start notepad $logfile

    
                 