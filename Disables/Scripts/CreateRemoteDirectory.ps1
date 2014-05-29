<################################################################################>
<##                                                                            ##>
<##                            RemoteDirectory.PS1                             ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##  This script creates a folder on the disables server and sets the proper   ##>
<##                                   rights.                                  ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>

#Assigning path a to a variable names Hdrive.

$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Disables"

#Assigns date and format.
 
#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\CreateRemoteDirectory\$date")
$Logfile = "$Hdrive\logs\$dateonly\CreateRemoteDirectory\$date\CreateRemoteDirectory.txt"

#Imports data file.

$Folders = Import-csv "$Hdrive\CSV\updates.csv"  

#Sets a loop to run code on all specified users in data file.

ForEach ($Folder in $Folders) { 

# Sets the variables to point to the proper columns in database.

$pfad = $Folder.Disabledfolder

New-Item -ItemType directory -Path "$pfad"

$Dir = $Folder.Name

$User = $Folder.Name

$Administrators = $Folder.Administrators

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

#Selects the folder and assigns the proper rights to it.

$ACL = Get-Acl "$Pfad" 
$acl.SetAccessRuleProtection($true,$false) | Set-Acl
$acl.Access | %{$acl.RemoveAccessRule($_)}
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$Manager", "$Perm1", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$Administrators", "$Perm", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$DomainAdmin", "$Perm", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$ServerAdmin", "$Perm", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$aGGcityDOPS", "$Perm1", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$aGGDataAdmins", "$Perm1", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 
$ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("$AccountAdmin", "$Perm1", "ContainerInherit, ObjectInherit", "None", "$Rule"))) 

#Applies settings on folder.

Set-Acl "$pfad" $Acl

#Gets the rights to the folder and exports it to a TXT file.
    
Get-Acl "$pfad" | Format-List >> $logfile

} 

#Opens TXT with notepad.

start notepad $Logfile