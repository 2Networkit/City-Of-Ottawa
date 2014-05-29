<################################################################################>
<##                                                                            ##>
<##                             ExchangeCalendar.PS1                           ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##  This script will add the check mark for the calendar setting in Exchange  ##>
<##   You may need to run this script 15 minutes after creating the mailbox    ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>

#Maps drive and sets array
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\create"

#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\ExchangeCalendar\$date")
$Logfile = "$Hdrive\logs\$dateonly\ExchangeCalendar\$date\ExchangeCalendar.txt"
$Email = "$Hdrive\Email\CreateEmail5.txt"

$array1 = @()
$array1 += import-Csv "$Hdrive\CSV\Updates.csv" 


    #adds the checkmark to every user in the array and outputs setting to logfile.
    ForEach ($user in $array1) 
                {

                $username = $user.username

                        Get-Mailbox -Identity $Username | Set-CalendarProcessing -ProcessExternalMeetingMessages $True

                        
                        $Status = Get-calendarprocessing -identity $username | select ProcessExternalMeetingMessages
                        
                       
 
                        #"User: $Username" | out-file -append $logfile
                            If ($Status.ProcessExternalMeetingMessages -ne $False)
                            {"Calendar Extrenal Meetings Messages is active for $Username" | out-file -append $logfile}
                            else
                            {"Error Enabling Calendar Extrenal Meetings Messages for $Username" | out-file -append $logfile}       
                }

#Creates link to EmilySolution log in email file
"$logfile" | out-file -append $Email

$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile
start notepad $logfile

#runs the ExchangeCalendarpropmt script to see if there was any errors after running this script.
Invoke-Expression \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\exchangecalendarprompt.ps1