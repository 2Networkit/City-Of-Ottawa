Remove-Item c:\temp\logs\one-of\RemoteDirectorie.txt

cls



$Folders = Import-csv "c:\temp\CSV\one-of\Updates.csv" 


ForEach ($Folder in $Folders) { 





$pfad = $Folder.Disabledfolderpath

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


Set-Acl "$pfad" $Acl
    
Get-Acl "$pfad" | Format-List >> "c:\temp\logs\one-of\RemoteDirectories.txt"




} 
c:\temp\logs\one-of\RemoteDirectories.txt



