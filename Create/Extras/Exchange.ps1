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
#Starts recording data to log file.
$ErrorActionPreference= 'silentlycontinue'

#Imports data file.
$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv" 



ForEach ($user in $array) 
{

$username = $user.username
$Email = $User.ADEmail
if (-not (Get-Mailbox -identity $username))

                {

                "Creating Account $username" | out-file -append $logfile

                "`n" | out-file -append $logfile
                "`n" | out-file -append $logfile

                

                #Outputs to the screen what settings have changed on the mailbox.
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
                $Firstname = $user.Firstname
                $Lastname = $user.Lastname
                $Middlename = $user.Initial
                               

                Enable-Mailbox -Identity $Username -Alias $Username -Database $Database
                Set-mailbox -Identity $Username -EmailAddressPolicyEnabled $false 
 
                #Creates the mailbox, applies the settings and then updates the log file.
                "User: $username" | out-file -append $logfile

                "`n" | out-file -append $logfile
                
                Set-Mailbox -Identity $Username -CustomAttribute1 $newattribute1 
                Set-Mailbox -Identity $Username -CustomAttribute8 $newattribute8 
                Set-Mailbox -Identity $Username -CustomAttribute10 $newattribute10 
                Set-Mailbox -Identity $Username -HiddenFromAddressListsEnabled $False
                Set-Mailbox -EmailAddresses "SMTP:$Email1", "SMTP:$Email2", "X400:C=US;A= ;P=Regional Municip;O=Lisgar;S=$FirstName;G=$LastName;I=$MiddleName;","RFAX:$Email", "RFAX:$RFAX" -Identity "city.a.ottawa.ca/Accounts/Recipients/$Username"
                Set-Mailbox -Identity $Username -PrimarySmtpAddress $Email1
                Set-Mailbox -Identity $Username -PrimarySmtpAddress $RFAX

                

                

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

                     get-mailbox -identity $username | FL *customattribute* | out-file -append $logfile
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

                            "Account already exists, Re-enabling Account $username" | out-file -append $logfile

                            "`n" | out-file -append $logfile
                            "`n" | out-file -append $logfile

                            "------------------------Account old settings for $username------------------------" | out-file -append $logfile

                            get-mailbox -identity $username | FL *customattribute* | out-file -append $logfile
                            get-mailbox -identity $username | FL *HiddenFromAddressListsEnabled* | out-file -append $logfile
                            get-mailbox -identity $username | FL *IssueWarningQuota* | out-file -append $logfile
                            get-mailbox -identity $username | FL *ProhibitSendquota* | out-file -append $logfile
                            Get-Mailbox -identity $UserName | FL *Quota* | out-file -append $logfile 
                            Get-Mailbox -identity $username | FL *GrantSendOnBehalfTo* | out-file -append $logfile 
                            Get-Mailbox -identity $username | FL *forward* | out-file -append $logfile  

                            "`n" | out-file -append $logfile 

                            
                            #Outputs to the screen what settings have changed on the mailbox.
                            
                            $newattribute1 = $user.attribute1
                            $newattribute8 = $user.attribute8
                            $newattribute10 = $user.attribute10
                            $Warning = [String]$user.warnings+'MB'
                            $Sendquota = [String]$user.quota+'MB'
                            $Defaults = $user.defaults

                            
                            
                            Set-Mailbox -Identity $username -CustomAttribute8 $newattribute8 
                            Set-Mailbox -Identity $username -CustomAttribute10 $newattribute10 
                            Set-Mailbox -Identity $username -HiddenFromAddressListsEnabled $False 
                                
                            if ($defaults -eq "Yes")
                             
                             {
                                Set-Mailbox -identity $username -ProhibitSendReceiveQuota Unlimited 
                                Set-Mailbox -identity $username -ProhibitSendReceiveQuota $False 
                                Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $True 
                             }
                                else
                                     {
                                         Set-Mailbox -identity $username -ProhibitSendReceiveQuota Unlimited 
                                         Set-Mailbox -identity $username -ProhibitSendReceiveQuota $False
                                         Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $False
                                         Set-Mailbox -identity $Username -ProhibitSendquota $SendQuota 
                                         Set-Mailbox -identity $Username -IssueWarningQuota $Warning
                                     }
                                    
                                    
                            "------------------------New existing mailbox settings for $username------------------------" | out-file -append $logfile
                                get-mailbox -identity $username | FL *customattribute* | out-file -append $logfile
                                get-mailbox -identity $username | FL *HiddenFromAddressListsEnabled* | out-file -append $logfile
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





