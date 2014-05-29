<################################################################################>
<##                                                                            ##>
<##                                Exchange.PS1                                ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##  This script creates a new user mailbox or re-enables a disabled mailbox.  ##>
<##  Gets actuall settings if disabled then changes those settings to reflect  ##>
<##                            the enable procedure.                           ##>
<##     The whole actual and changed settings are exported to a TXT file       ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>



#setting powershell window size
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 300
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 132
$pswindow.windowsize = $newsize

#Assigning path a to a variable names Hdrive
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\create"

#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\Rfax\$date")
$Logfile = "$Hdrive\logs\$dateonly\Rfax\$date\Rfax.txt"

#Command to not show errors on powershell window.
#$ErrorActionPreference= 'silentlycontinue'

#Imports data file.
$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv" 


#Start of loop to set exchange settings to new account or existing one.
ForEach ($user in $array)
 
{
$username = $user.username
$RFAX = $user.RFax

$Temp = Get-Mailbox -Identity $Username
$Temp.EmailAddresses += ("$Rfax")
Set-Mailbox -Identity $Username -EmailAddresses $Temp.EmailAddresses
Get-Mailbox -identity $Username | List PrimarySmtpAddress, EmailAddresses | out-file -append $logfile

"`n" | out-file -append $logfile
          " ________________________________________________________" | out-file -append $logfile
          "`n" | out-file -append $logfile
          "`n" | out-file -append $logfile
}

$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile
start notepad $logfile
 