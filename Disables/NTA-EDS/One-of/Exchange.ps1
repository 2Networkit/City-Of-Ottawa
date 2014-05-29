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

Remove-Item "c:\temp\logs\one-of\Exchange.txt"

start-transcript -path "c:\temp\logs\one-of\Exchange.txt"
{
}
import-Csv 'c:\temp\CSV\one-of\Updates.csv' | ForEach-Object {



#$USR.TrimStart("@{user=")

Write-Output "User:" $_.name

Get-Mailbox $_.Name | Format-List *Quota



Get-Mailbox -identity $_.Name | FL *GrantSendOnBehalfTo* 

Get-Mailbox -identity $_.Name | FL *forward*
{
}




$USERS= Get-Mailbox $_.Name | Get-MailboxPermission | where {$_.user.tostring() -notlike "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false -and $_.Deny -eq $false} | where {($_.user.tostring() -notlike "A\Exchange Servers" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where{($_.user.tostring() -notlike "A\Exchange Trusted SubSystem" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "city\ArchiveOneAdmin" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "City\BesAdminE2k10" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "City\Exchange Administrators" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike"City\Exchange Services" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)} | where{($_.user.tostring() -notlike "NT Authority System" -and $_.IsInherited -eq $false -and $_.Deny -eq$false)} | where {($_.user.tostring() -notlike "s-1-5-21-215967948-3801397714-1255040003-3106" -and$_.IsInherited -eq $false -and $_.Deny -eq $false)} | where {($_.user.tostring() -notlike "s-1-5-21-215967948-3801397714-1255040003-73486" -and $_.IsInherited -eq $false -and $_.Deny -eq $false)}  | select user


 foreach ($USER in $USERS )

{

[string]$CURRENT_USER = $USER


$CURRENT_USER = $CURRENT_USER.Substring(7).TrimEnd("}")

Write-Output "Granted Full Access to Mailbox"
Write-Output $CURRENT_USER

 
trap {Continue}

 
Remove-MailboxPermission -Identity $_.Name -user $CURRENT_USER -InheritanceType 'All' -AccessRights 'All' -confirm:$False  -ErrorAction stop

Add-MailboxPermission -Identity $_.Name -User $CURRENT_USER -Deny -AccessRights 'All' -confirm:$False -ErrorAction stop



}
{
}
{
}
Write-Output "Custom Attributes: Mailbox set to inactive"

Set-Mailbox -Identity $_.name -CustomAttribute8 $_.attribute8 

Write-Output "Custom Attributes: Mailbox set 0MB"
 
Set-Mailbox -Identity $_.name -CustomAttribute10 $_.attribute10 
 
Write-Output "General: Mailbox Hidden From Address List" 

Set-Mailbox -Identity $_.name -HiddenFromAddressListsEnabled $true 

Write-Output "Mailbox Setting - Issue Warning Set to Off"

Set-Mailbox -identity $_.name -IssueWarningQuota Unlimited 

Write-Output "Mailbox Setting - Storage Quota: Prohibit send at set to Off"

Set-Mailbox -identity $_.name -ProhibitSendquota Unlimited 

Write-Output "Mailbox Setting - Storage Quota: Prohibit Send and Receive set to 0"

Set-Mailbox -identity $_.name -ProhibitSendReceiveQuota 0 

Write-Output "Mailbox Setting - Storage Quota: Defaults Set To OFF"

Set-Mailbox -identity $_.name -UseDatabaseQuotaDefaults $false 

Write-Output "Mail Flow Settings - Delivery Options: Grant Send On Behalf Set To Off"

set-Mailbox -Identity $_.name -GrantSendOnBehalfTo $null 

Write-Output "Mail Flow Settings - Delivery Options: Forwarding Set To Off"

set-mailbox -Identity $_.name -ForwardingAddress $null 
{
}

 Write-output ________________________________________________________
 {
 }
 {
 }

                                           } 
Write-Output "Exchange.ps1 done!"
stop-transcript
C:\temp\logs\one-of\Exchange.txt