<################################################################################>
<##                                                                            ##>
<##                          ExchangeCalendarPrompt.PS1                        ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##    This script will ask you if any accounts in exchangeCalendarlog file    ##>
<##   got errors applying the processexternalMeetings setting. If you select   ##>
<##     yes:, the exchangecalendar script runs once again. If you press No:    ##>
<##                               the script exits.                            ##>
<##  after each run of the exchangeCalendar, this script is ran automatically. ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>


#Choice menu with yes and no option.
$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",""
$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No",""
$choices = [System.Management.Automation.Host.ChoiceDescription[]]($Yes,$No)
$caption = "Warning!"
$message = "Does the ExchangeCalendar.txt file return errors? "
$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
if($result -eq 0) { Write-Host "Re-running ExchangeCalendar script"
Invoke-Expression S:\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\exchangecalendar.ps1}
if($result -eq 1) { Write-Host "Exiting Script"
exit }
