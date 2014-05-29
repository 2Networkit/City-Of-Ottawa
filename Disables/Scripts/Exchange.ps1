<################################################################################>
<##                                                                            ##>
<##                                Exchange.PS1                                ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##  This script opens user's mailbox and gets actuall settings then changes   ##>
<##             those settings to reflect the disable procedure.               ##>
<##     The whole actual and changed settings are exported to a TXT file       ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>


#Sets powershell window size.

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
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\disables"

#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\Exchange\$date")

$Logfile = "$Hdrive\logs\$dateonly\Exchange\$date\Exchange.txt"
#Starts recording data to log file.


#Imports data file.
$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv" 
ForEach ($user in $array)
{




#Outputs to screen the name, quota, send on behalf and forwarding actual settings.
$username = $user.name
"User: $username" | out-file -append $logfile 

Get-Mailbox $UserName | Format-List *Quota | out-file -append $logfile 

Get-Mailbox -identity $username | FL *GrantSendOnBehalfTo* | out-file -append $logfile 

Get-Mailbox -identity $username | FL *forward* | out-file -append $logfile  

"`n" | out-file -append $logfile 

#Gets all accounts that has full access on the mailbox except for the ones that are part of the defaults.

$USERS= Get-Mailbox $userName | Get-MailboxPermission | where {($_.user.tostring() -notlike "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "A\Exchange Servers" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "A\Exchange Trusted SubSystem" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "city\ArchiveOneAdmin" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "City\BesAdminE2k10" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "City\Exchange Administrators" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike"City\Exchange Services" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "NT Authority System" -and $_.IsInherited -eq $false -and $_.Deny -eq$false)} | where {($_.user.tostring() -notlike "s-1-5-21-215967948-3801397714-1255040003-3106" -and$_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "s-1-5-21-215967948-3801397714-1255040003-73486" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)}  | select user


#Sets a loop to run code on all specified users in data file.
"Granted Full Access to Mailbox" | out-file -append $logfile
foreach ($RECORD in $USERS )
{

#Changes users found to a string value. 

[string]$CURRENT_USER = $RECORD
$CURRENT_USER = $CURRENT_USER.Substring(7).TrimEnd("}")


#Outputs to screen users having full access to mailbox except default ones.
 
$CURRENT_USER | out-file -append $logfile  


#Removes the showed users that were granted full access right to the mailbox. 

trap {Continue}

If ($Current_user -ne $null)
{
Remove-MailboxPermission -Identity $userName -user $CURRENT_USER -InheritanceType 'All' -AccessRights 'FULLACCESS' -confirm:$False   
}

}


#Outputs to the screen what settings have changed on the mailbox.
$newattribute8 = $user.attribute8
$newattribute10 = $user.attribute10
$attribute8 = get-mailbox -identity  $username | select customattribute8
$attribute8 = $attribute8.customattribute8
$attribute10 = get-mailbox -identity  $username | select customattribute10
$attribute10 = $attribute10.customattribute10
$hidden = get-mailbox -identity  $username | select HiddenFromAddressListsEnabled
$hidden = $hidden.HiddenFromAddressListsEnabled
$Warning = get-mailbox -identity  $username | select IssueWarningQuota
$Warning = $Warning.IssueWarningQuota
$Sendquota = get-mailbox -identity  $username | select ProhibitSendquota
$Sendquota = $Sendquota.ProhibitSendquota
$ReceiveQuota = get-mailbox -identity  $username | select ProhibitSendReceiveQuota
$ReceiveQuota = $ReceiveQuota.ProhibitSendReceiveQuota
$Quotadefaults = get-mailbox -identity  $username | select UseDatabaseQuotaDefaults
$Quotadefaults = $Quotadefaults.UseDatabaseQuotaDefaults


"Old Custom Attribute8: $attribute8" | out-file -append $logfile
Set-Mailbox -Identity $username -CustomAttribute8 $newattribute8 
"New Custom Attribute8: Mailbox set to inactive" | out-file -append $logfile 

"Old Custom Attribute10: $attribute10" | out-file -append $logfile
Set-Mailbox -Identity $username -CustomAttribute10 $newattribute10  
"New Custom Attribute10: Mailbox set 0MB" | out-file -append $logfile  
 
"Old General: Mailbox Hidden From Address List: $hidden" | out-file -append $logfile 
Set-Mailbox -Identity $username -HiddenFromAddressListsEnabled $true
"New General: Mailbox Hidden From Address List" | out-file -append $logfile  

"Old Mailbox Setting - Issue Warning Set to: $warning" | out-file -append $logfile    
Set-Mailbox -identity $username -IssueWarningQuota Unlimited
"New Mailbox Setting - Issue Warning Set to Off" | out-file -append $logfile  

"Old Mailbox Setting - Storage Quota: Prohibit send at set to: $sendquota" | out-file -append $logfile
Set-Mailbox -identity $username -ProhibitSendquota Unlimited 
"New Mailbox Setting - Storage Quota: Prohibit send at set to Off" | out-file -append $logfile

"Old Mailbox Setting - Storage Quota: Prohibit Send and Receive set to: $receivequota" | out-file -append $logfile
Set-Mailbox -identity $username -ProhibitSendReceiveQuota 0
"Mailbox Setting - Storage Quota: Prohibit Send and Receive set to 0" | out-file -append $logfile

"Mailbox Setting - Storage Quota: Defaults Set To: $quotedefaults" | out-file -append $logfile
Set-Mailbox -identity $username -UseDatabaseQuotaDefaults $false 
"Mailbox Setting - Storage Quota: Defaults Set To OFF" | out-file -append $logfile


"Mail Flow Settings - Delivery Options: Grant Send On Behalf Set To Off" | out-file -append $logfile
set-Mailbox -Identity $username -GrantSendOnBehalfTo $null 

"Mail Flow Settings - Delivery Options: Forwarding Set To Off" | out-file -append $logfile
set-mailbox -Identity $username -ForwardingAddress $null 


 " ________________________________________________________" | out-file -append $logfile
 }
 
#Informs that script is done, trims end of each line to remove extra spaces and then opens the log file to show the data.
                                          

$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile
start notepad $logfile