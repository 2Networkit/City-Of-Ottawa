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
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\"

#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\GroupsFetch\$date")
$Logfile = "$Hdrive\logs\$dateonly\GroupsFetch\$date\groupsfetch.txt"


$array = @()
$array += import-Csv "c:\temp\Updates.csv" 





ForEach ($user in $array)
{
$Username = $user.Clone

#Displays the data for user.

 " ________________________________________________________" | out-file -append $logfile

           
"***Username: $Username" | out-file -append $logfile

#Gets the groups membership for the user account.
   
"***Groups:" | out-file -append $logfile

   $membership =     get-adprincipalgroupmembership $Username | select name
   $membership | out-file -append $logfile
   #Opens the log file to show the data.
$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile



}



Remove-Item 'C:\temp\membersof1.csv'

$SearchBase = "OU=Distribution lists,OU=groups,DC=city,DC=a,DC=ottawa,DC=ca"
$arrayofgroups = Get-ADGroup -Filter * -SearchBase $SearchBase

foreach ($item in $arrayofgroups) {
$group = $item.name
    Get-ADGroup -Identity $item -Properties * | 
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
    select @{n='Group';e={$group}}, @{n='Description';e={$_.description}}, @{n='Info';e={$_.Info}} | Export-CSV -append 'C:\temp\membersof.csv' –NoTypeInformation
}

$SearchBase = "OU=Global Groups,OU=groups,DC=city,DC=a,DC=ottawa,DC=ca"
$arrayofgroups = Get-ADGroup -Filter * -SearchBase $SearchBase

foreach ($item in $arrayofgroups) {
$group = $item.name
    Get-ADGroup -Identity $item -Properties * | 
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
    select @{n='Group';e={$group}}, @{n='Description';e={$_.description}}, @{n='Info';e={$_.Info}} | Export-CSV -append 'C:\temp\membersof.csv' –NoTypeInformation
}

$List = Import-Csv 'C:\temp\membersof.csv' | select * -ExcludeProperty Description,Info 

$base = import-csv c:\temp\membersof.csv

import-csv c:\temp\list.csv |
where {$base -match $_} |
out-file -append "c:\temp\diff.csv"
(gc c:\temp\diff.csv) | % {$_ -replace '-----', ""} | % {$_ -replace 'Group', ""} | ? {$_.trim() -ne "" } | out-file c:\temp\Diff.csv -Fo -En ascii
   $content = Get-Content "c:\temp\diff.csv"
   $content | Foreach {$_.TrimEnd()} | Set-Content c:\temp\diff.csv









ForEach ($user in $array)
{
$Username = $user.Username
$Clone = $user.Clone


#Displays the data for user.

 " ________________________________________________________" | out-file -append $logfile

           
"***Clone Username: $Clone" | out-file -append $logfile

#Gets the groups membership for the user account.
   
"***Groups:" | out-file -append $logfile

   $membership =     get-adprincipalgroupmembership $Clone | select name
   $membership | out-file -append $list

"Groups to be added from Clone to User" | out-file -append $logfile


$base = import-csv "c:\temp\membersof.csv"
import-csv "c:\temp\list.csv" |
where {$base -match $_} |
out-file -append "c:\temp\diff.csv"
(gc "c:\temp\diff.csv") | % {$_ -replace '-----', ""} | ? {$_.trim() -ne "" } | out-file "c:\temp\diff.csv" -Fo -En ascii
   $content = Get-Content "c:\temp\diff.csv"
   $content | Foreach {$_.TrimEnd()} | Set-Content "c:\temp\diff.csv" | out-file -append $logfile
 
 $Difference = "c:\temp\diff.csv" 
 
   ForEach ($Groups in $Difference)
   {
   $Group = $Groups.group

   Add-ADGroupMember $Group $username
   }


}


Remove-Item 'C:\temp\membersof.csv'

