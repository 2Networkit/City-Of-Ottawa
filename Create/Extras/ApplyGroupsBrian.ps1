<################################################################################>
<##                                                                            ##>
<##                                 Groups.PS1                                 ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##     This script opens user's AD record and pulls the groups its part of.   ##>
<##    It then displays the Marval call, the user's full name, the username,   ##>
<##  the supervisor name, The home share location, the date you do the disable ##>
<## the homefolder deleted date, the disabled folder path, the disabled folder ##> 
<##           deletetion date and the groups the account is part of.           ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>

#Assigning path a to a variable names Hdrive
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create"

#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\Groups\$date")
$Logfile = "$Hdrive\logs\$dateonly\Groups\$date\groups.txt"
$clone = "$Hdrive\logs\$dateonly\Groups\$date\Clone.csv"
$clone1 = "$Hdrive\logs\$dateonly\Groups\$date\Clone1.csv"
$DiffGroups = "$Hdrive\logs\$dateonly\Groups\$date\Diffgroups.csv"
$members = "$Hdrive\logs\$dateonly\Groups\$date\Members.csv"
$membersof = "$Hdrive\logs\$dateonly\Groups\$date\membersof.csv"
$membersof1 = "$Hdrive\logs\$dateonly\Groups\$date\membersof1.csv"
$Groupresults =@()

$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv"

$SearchBase = "OU=Distribution lists,OU=groups,DC=city,DC=a,DC=ottawa,DC=ca"
$arrayofgroups = Get-ADGroup -Filter * -SearchBase $SearchBase

foreach ($item in $arrayofgroups) {
$group = $item.name
    $Groupresults += Get-ADGroup -Identity $item -Properties * | 
    Where {$_.Info -notlike "Owner*"} |
    Where {$_.Info -notlike "M*Owner*"} | 
    Where {$group -notlike "GLCY*"} | 
    Where {$group -notlike ">Employee Wellness Mailing"} | 
    Where {$group -notlike ">Benefits Mailing"} | 
    Where {$group -notlike "=PS*"} | 
    Where {$group -notlike "=People Services*"} | 
    Where {$group -notlike "cGGIClientservicesLimited_r"} |
    Where {$group -notlike "RAS Users"} | 
    Where {$group -notlike "*Boardroom"} |
    Where {$group -notlike "Networkusers"} | 
    Where {$group -notlike "CIPP*"} | 
    Where {$group -notlike "CUPE*"} | 
    Where {$group -notlike "MAPPINGS Y DRIVE"} | 
    Where {$group -notlike "MAPPINGS Y DRIVESAP"} | 
    Where {$group -notlike "Z_I*"} | 
    Where {$group -notlike "SAPR*"} | 
    Where {$group -notlike "CLGI*"} | 
    Where {$group -notlike "CGGS*"} | 
    Where {$group -notlike "CGGD*"} | 
    Where {$group -notlike "CGGW*"} | 
    Where {$group -notlike "CGGI*"} | 
    Where {$group -notlike "CGGR*"} | 
    Where {$group -notlike "PGM*"} | 
    Where {$group -notlike "TRAN PROJ"} | 
    Where {$group -notlike "OTX*"} | 
    Where {$group -notlike "cGG MgMt*"} | 
    Where {$group -notlike "+ Management*"} |
    Where {$group -notlike ">Benefits Inquiries"} |
    Where {$group -notlike "<Restricted*"} |
    Where {$group -notlike "=TUPW"} |
    Where {$group -notlike "cGG EMPTES"} |
    Where {$group -notlike "CMMP002 e-mail users"} |
    Where {$group -notlike "HR*"} |
    Where {$group -notlike "boardroom*"} |
    Where {$group -notlike ">C2C ArchiveOne Email Auto delete DC4"} |
    Where {$group -notlike ">C2C ArchiveOne Email Auto delete DC1"} |
    select @{n='Group';e={$group}} 
}

$SearchBase = "OU=Global Groups,OU=groups,DC=city,DC=a,DC=ottawa,DC=ca"
$arrayofgroups = Get-ADGroup -Filter * -SearchBase $SearchBase

foreach ($item in $arrayofgroups) {
$group = $item.name
$Groupresults += Get-ADGroup -Identity $item -Properties * | 
    Where {$_.Info -notlike "Owner*"} |
    Where {$_.Info -notlike "M*Owner*"} | 
    Where {$group -notlike "GLCY*"} |
    Where {$group -notlike ">Employee Wellness Mailing"} | 
    Where {$group -notlike ">Benefits Mailing"} | 
    Where {$group -notlike "=PS*"} | 
    Where {$group -notlike "=People Services*"} | 
    Where {$group -notlike "cGGIClientservicesLimited_r"} |
    Where {$group -notlike "RAS Users"} | 
    Where {$group -notlike "*Boardroom"} |
    Where {$group -notlike "Networkusers"} | 
    Where {$group -notlike "CIPP*"} | 
    Where {$group -notlike "CUPE*"} | 
    Where {$group -notlike "MAPPINGS Y DRIVE"} | 
    Where {$group -notlike "MAPPINGS Y DRIVESAP"} | 
    Where {$group -notlike "Z_I*"} | 
    Where {$group -notlike "SAPR*"} | 
    Where {$group -notlike "CLGI*"} | 
    Where {$group -notlike "CGGS*"} | 
    Where {$group -notlike "CGGD*"} | 
    Where {$group -notlike "CGGW*"} | 
    Where {$group -notlike "CGGI*"} | 
    Where {$group -notlike "CGGR*"} | 
    Where {$group -notlike "PGM*"} | 
    Where {$group -notlike "TRAN PROJ"} | 
    Where {$group -notlike "OTX*"} | 
    Where {$group -notlike "cGG MgMt*"} | 
    Where {$group -notlike "+ Management*"} |
    Where {$group -notlike ">Benefits Inquiries"} |
    Where {$group -notlike "<Restricted*"} |
    Where {$group -notlike "=TUPW"} |
    Where {$group -notlike "cGG EMPTES"} |
    Where {$group -notlike "CMMP002 e-mail users"} |
    Where {$group -notlike "HR*"} |
    Where {$group -notlike ">C2C ArchiveOne Email Auto delete DC4"} |
    Where {$group -notlike ">C2C ArchiveOne Email Auto delete DC1"} |
    select @{n='Group';e={$group}} 

}
$Groupresults | % {$_ -replace '-----', $NULL} | ? {$_.trim() -ne $NULL } |Export-CSV -append $members –NoTypeInformation


ForEach ($user in $array)
{
$ErrorActionPreference= 'silentlycontinue'
$Username = $user.Clone
$Newuser = $user.Username
$Exchange = $user.Attribute1
$Exchangegroup = $user.EXCGroup


   $membership = get-adprincipalgroupmembership $Username | select name | out-file -append $clone
   

$templist = (gc $clone) | % {$_ -replace '----', $NULL} | ? {$_.trim() -ne $NULL } 
$content = $templist
   $content | Foreach {$_.TrimEnd()} | Set-Content $clone1
   Remove-Item $clone





get-content $clone1 | where {$Groupresults -match $_} | out-file -append $DiffGroups
(gc $DiffGroups) | % {$_ -replace '-----', ""} |  % {$_ -replace 'Group', ""} |? {$_.trim() -ne "" } | out-file -append $DiffGroups
   $content = Get-Content $DiffGroups
   $content | Foreach {$_.TrimEnd()} | Set-Content $DiffGroups
 


   $Difference = @(Import-Csv $DiffGroups)
   ForEach ($Groups in $Difference)
   {
   $Group = $Groups.name

   if ((get-adgroup "CN=$group,OU=Distribution lists,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca") -eq $true)
   {
   Add-ADGroupMember  -identity "CN=$group,OU=Distribution lists,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser 
   else 
   Add-ADGroupMember  -identity "CN=$group,OU=Global Groups,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser

   if ($Exchange -eq "DC1" -or $Exchange -eq "DC4")
                
                {
                     Add-ADGroupMember  -identity "CN=$exchangegroup,OU=Distribution lists,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser
                
                }
                else
                        {                           
                        }
                                              
    }
   Remove-Item$DiffGroups
   }


Remove-Item $membersof
Remove-Item $membersof1
                        
 


$array1 = @()
$array1 += import-Csv "$Hdrive\CSV\Updates.csv"  

   #Displays the data for user.

 " ________________________________________________________" | out-file -append $Logfile
 "`n" | out-file -append $Logfile
 "`n" | out-file -append $Logfile

ForEach ($user in $array1)
{
$Username = $user.Clone
$Newuser = $user.Username
           
"***New Account Groups: $Newuser" | out-file -append $Logfile
 $membership1 = get-adprincipalgroupmembership $newuser | select name | out-file -append $Logfile
   $membership1 | out-file -append $Logfile

"***Clone Account Groups: $Username" | out-file -append $Logfile
 $membership = get-adprincipalgroupmembership $Username | select name | out-file -append $Logfile
   $membership | out-file -append $Logfile
"`n" | out-file -append $Logfile
"`n" | out-file -append $Logfile

}
Remove-Item $clone1

$content = Get-Content $Logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $Logfile









