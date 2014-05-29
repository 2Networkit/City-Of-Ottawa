<################################################################################>
<##                                                                            ##>
<##                             Homedirectory.PS1                              ##>
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


#Assigns logdrive, date and format & logfile
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\ADCredentials\$date")
$Email = "$Hdrive\Email\CreateEmail2.txt"
$Logfile = "$Hdrive\logs\$dateonly\ADCredentials\$date\ADCredentials.csv"
$Folders = Import-csv "$Hdrive\CSV\Updates.csv" 
$ErrorActionPreference= 'silentlycontinue'

#Creates a Homefolder and sets it's permissions. Also sets proper credentials in AD for account.
ForEach ($Folder in $Folders) 
         { 

            $pfad = $Folder.UserHomedirectory

            $User = $Folder.Username

            $Administrators = $Folder.Admins

            $DomainAdmin = $Folder.DomainAdmin

            $ServerAdmin = $Folder.ServerAdmin

            $aGGcityDOPS = $Folder.aGGcityDOPS

            $aGGDataAdmins = $Folder.aGGDataAdmins

            $AccountAdmin = $Folder.AccountAdmin

            $Manager = $Folder.Supervisorusername

            $Perm = $Folder.Perm

            $Perm1 = $Folder.Perm1

            $Perm2 = $Folder.Perm2

            $Rule = $Folder.Rule

            $Share = $Folder.Userhomeshare


                    if ($Share -eq $Null)
                        {
                            Set-ADUser $user -UserPrincipalName "$($user)@city.a.ottawa.ca" -ScriptPath "logon.bat"
                            Set-ADUser $user -HomeDirectory $null -homedrive $null

                            "AD Credentials set for $User" | out-file -append $logfile

                             " ________________________________________________________" | out-file -append $logfile
                        }

                            Else

                                    {

                                        New-Item -ItemType directory -Path "$pfad"
                                        $Acl = Get-Acl "$Pfad"
                                        $Acl.SetAccessRuleProtection($true,$false) | Set-Acl
                                        $Acl.Access | %{$acl.RemoveAccessRule($_)}
                                        $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$User", "$Perm1", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
                                        $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$Administrators", "$Perm", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
                                        $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$DomainAdmin", "$Perm", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
                                        $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$ServerAdmin", "$Perm", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
                                        $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$aGGcityDOPS", "$Perm1", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
                                        $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$aGGDataAdmins", "$Perm1", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
                                        $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$AccountAdmin", "$Perm1", "ContainerInherit, ObjectInherit", "None", "$Rule")))
                                        Set-Acl "$pfad" $Acl
                                        Get-Acl "$pfad" | Format-List >> "$Logfile"
                                        Set-ADuser -Identity $User -UserPrincipalName "$($user)@city.a.ottawa.ca" 
                                        Set-ADUser $user -HomeDirectory $null -homedrive $null
                                        Set-ADUser $user -HomeDirectory $Share -homedrive H -ScriptPath "logon.bat"

                                        "AD Credentials set and homefolder created at $share for $User" | out-file -append $logfile
                                        " ________________________________________________________" | out-file -append $logfile
                                    }


         }
#Creates link to Homefolder log in email file      
"$logfile" | out-file -append $Email 


#Opens the log file to show the data.
$content = Get-Content $Logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $Logfile
#start notepad $logfile



