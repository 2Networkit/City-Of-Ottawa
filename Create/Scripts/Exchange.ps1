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
Mkdir ($Hdrive+"\Logs\$dateonly\Exchange\$date")
$Logfile = "$Hdrive\logs\$dateonly\Exchange\$date\Exchange.txt"

#Command to not show errors on powershell window.
$ErrorActionPreference= 'silentlycontinue'

#Imports data file.
$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv" 


#Start of loop to set exchange settings to new account or existing one.
ForEach ($user in $array)
 
{
$username = $user.username
$Email = $User.ADEmail
$RFAX = $user.RFax

    #Checks if mailbox already exists on Exchange Server
    if (-not (Get-Mailbox -identity $username))

        {
          $Database = $User.EmailDatabase
          $newattribute1 = $user.attribute1
          $newattribute8 = $user.attribute8
          $newattribute10 = $user.attribute10
          $Warning = [String]$user.warnings+'MB'
          $Sendquota = [String]$user.quota+'MB'
          $Defaults = $user.defaults
          $Email1 = $user.PrimaryEmail
          $Email2 = $user.SecondaryEmail
          $RFAX = $user.RFax
          $x400 = $user.X400
          $Firstname = $user.Firstname
          $Lastname = $user.Lastname
          $Middlename = $user.Initial
          
          

          "Creating Account $username" | out-file -append $logfile
          "`n" | out-file -append $logfile
          "`n" | out-file -append $logfile
                     
          #Creates the mailbox, applies the settings and then updates the log file.
          Enable-Mailbox -Identity $Username -Alias $Username -Database $Database
          Set-mailbox -Identity $Username -EmailAddressPolicyEnabled $false 
          Set-Mailbox -Identity $Username -CustomAttribute1 $newattribute1 
          Set-Mailbox -Identity $Username -CustomAttribute8 $newattribute8 
          Set-Mailbox -Identity $Username -CustomAttribute10 $newattribute10 
          Set-Mailbox -Identity $Username -HiddenFromAddressListsEnabled $False
          Set-Mailbox -Identity $Username -PrimarySmtpAddress $Email1

          #Checks to see if the email box has a Transpo or library email and applies SMTP, RFAX and X400 settings required.
              if ($Email1 -contains "transpo" -or $Email1 -contains "biblioottawalibrary")
                
                  {
                     Set-Mailbox -Identity $Username -EmailAddresses "SMTP:$Email1", "SMTP:$Email2", "X400:$x400"
                     $Temp = Get-Mailbox -Identity $Username
                     $Temp.EmailAddresses += ("$Rfax")
                     Set-Mailbox -Identity $Username -EmailAddresses $Temp.EmailAddresses
                     
                  }

                   else

                        {
                           Set-Mailbox -Identity $Username -EmailAddresses "SMTP:$Email1", "X400:$X400"
                           $Temp = Get-Mailbox -Identity $Username
                           $Temp.EmailAddresses += ("$Rfax")
                           Set-Mailbox -Identity $Username -EmailAddresses $Temp.EmailAddresses

                        }
                
                          #Checks to see if the email box is using default settings or not and applies settings required.
                          if ($defaults -eq "Yes")
                
                              {
                                 Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $True 
                              }

                               else

                                    {
                                       Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $False
                                       Set-Mailbox -identity $Username -ProhibitSendquota $SendQuota
                                       Set-Mailbox -identity $Username -IssueWarningQuota $Warning
                                    }

             
          "------------------------New mailbox created for $username with the following settings:------------------------" | out-file -append $logfile
          Get-mailbox -identity $username | FL *customattribute* | out-file -append $logfile
          Get-Mailbox -identity $UserName | FL *Quota* | out-file -append $logfile 
          Get-Mailbox -identity $username | FL *GrantSendOnBehalfTo* | out-file -append $logfile 
          Get-Mailbox -identity $username | FL *forward* | out-file -append $logfile
          Get-Mailbox -identity $username | FL *ProcessExternalMeetingMessages* | out-file -append $logfile
          Get-Mailbox -identity $Username | List PrimarySmtpAddress, EmailAddresses | out-file -append $logfile
  
          "`n" | out-file -append $logfile
          " ________________________________________________________" | out-file -append $logfile
          "`n" | out-file -append $logfile
          "`n" | out-file -append $logfile
        }    
          
          Else
          
               {
                 #Account already exists and changes settings to enable it.
                 "Account already exists, Re-enabling Account $username" | out-file -append $logfile
                 "`n" | out-file -append $logfile
                 "`n" | out-file -append $logfile
                 "------------------------Account old settings for $username------------------------" | out-file -append $logfile
                 "`n" | out-file -append $logfile
                   
                 $newattribute1 = $user.attribute1
                 $newattribute8 = $user.attribute8
                 $newattribute10 = $user.attribute10
                 $Warning = [String]$user.warnings+'MB'
                 $Sendquota = [String]$user.quota+'MB'
                 $Defaults = $user.defaults
                 
                 #Gets actual settings of mailbox and outputs them to the logfile.          
                 Get-mailbox -identity $username | FL *customattribute* | out-file -append $logfile
                 Get-mailbox -identity $username | FL *HiddenFromAddressListsEnabled* | out-file -append $logfile
                 Get-mailbox -identity $username | FL *IssueWarningQuota* | out-file -append $logfile
                 Get-mailbox -identity $username | FL *ProhibitSendquota* | out-file -append $logfile
                 Get-Mailbox -identity $UserName | FL *Quota* | out-file -append $logfile 
                 Get-Mailbox -identity $username | FL *GrantSendOnBehalfTo* | out-file -append $logfile 
                 Get-Mailbox -identity $username | FL *forward* | out-file -append $logfile  
                 
                 #Sets mailbox with new settings.
                 Set-Mailbox -Identity $username -CustomAttribute8 $newattribute8 
                 Set-Mailbox -Identity $username -CustomAttribute10 $newattribute10 
                 Set-Mailbox -Identity $username -HiddenFromAddressListsEnabled $False 
                    
                      #Checks to see if the email box is using default settings or not and applies settings required.            
                      if ($defaults -eq "Yes")
                             
                          {
                             Set-Mailbox -identity $username -ProhibitSendReceiveQuota Unlimited 
                             Set-Mailbox -identity $username -ProhibitSendReceiveQuota $False 
                             Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $True 
                          }
                                    
                             Else

                                  {
                                     Set-Mailbox -identity $username -ProhibitSendReceiveQuota Unlimited 
                                     Set-Mailbox -identity $username -ProhibitSendReceiveQuota $False
                                     Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $False
                                     Set-Mailbox -identity $Username -ProhibitSendquota $SendQuota 
                                     Set-Mailbox -identity $Username -IssueWarningQuota $Warning
                                  }
                                    
                 #Gets new settings of mailbox and outputs them to the logfile.                    
                 "------------------------New existing mailbox settings for $username------------------------" | out-file -append $logfile

                 Get-mailbox -identity $username | FL *customattribute* | out-file -append $logfile
                 Get-mailbox -identity $username | FL *HiddenFromAddressListsEnabled* | out-file -append $logfile
                 Get-Mailbox -identity $UserName | FL *Quota* | out-file -append $logfile 
                 Get-Mailbox -identity $username | FL *GrantSendOnBehalfTo* | out-file -append $logfile 
                 Get-Mailbox -identity $username | FL *forward* | out-file -append $logfile
                 Get-Mailbox -identity $username | FL *ProcessExternalMeetingMessages* | out-file -append $logfile
                 Get-Mailbox -identity $Username | List PrimarySmtpAddress, EmailAddresses | out-file -append $logfile

                 "`n" | out-file -append $logfile
                 " ________________________________________________________" | out-file -append $logfile
                 "`n" | out-file -append $logfile
                 "`n" | out-file -append $logfile
               }

}




#Informs that script is done, trims end of each line to remove extra spaces and then opens the log file to show the data.

$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile
start notepad $logfile





