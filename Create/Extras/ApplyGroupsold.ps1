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
Mkdir ($Hdrive+"\Logs\$dateonly\Groups\$date")
$Logfile = "$Hdrive\logs\$dateonly\Groups\$date\groups.txt"


$array = @()
$array += import-Csv "c:\temp\Updates.csv" 

ForEach ($user in $array)
{
$Username = $user.Clone
$Newuser = $user.Username



   $membership = get-adprincipalgroupmembership $Username | select name | out-file -append c:\temp\clone.csv
   

$templist = (gc c:\temp\clone.csv) | % {$_ -replace '----', ""} | ? {$_.trim() -ne "" } 
$content = $templist
   $content | Foreach {$_.TrimEnd()} | Set-Content c:\temp\newclone1.csv
   Remove-Item 'C:\temp\clone.csv'
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


(gc c:\temp\membersof.csv) | % {$_ -replace '-----', ""} | ? {$_.trim() -ne "" } | out-file -append c:\temp\membersof1.csv -Fo -En ascii

Import-Csv 'C:\temp\membersof1.csv' | select * -ExcludeProperty Description,Info | Export-CSV -append 'C:\temp\membersof2.csv' –NoTypeInformation

$base = get-content c:\temp\membersof1.csv
get-content C:\temp\newclone1.csv | where {$base -match $_} | out-file -append c:\temp\diff.csv
(gc c:\temp\diff.csv) | % {$_ -replace '-----', ""} |  % {$_ -replace 'Group', ""} |? {$_.trim() -ne "" } | out-file -append c:\temp\Diff.csv
   $content = Get-Content c:\temp\diff.csv
   $content | Foreach {$_.TrimEnd()} | Set-Content c:\temp\diff.csv
 Remove-Item 'C:\temp\membersof1.csv'
  Remove-Item 'C:\temp\membersof2.csv'





 $Difference = @(Import-Csv "c:\temp\diff.csv")
 
   ForEach ($Groups in $Difference)
   {
   $ErrorActionPreference= 'silentlycontinue'

   $Group = $Groups.name
   Add-ADGroupMember  -identity "CN=$group,OU=Distribution lists,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser 
   Add-ADGroupMember  -identity "CN=$group,OU=Global Groups,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser
   }


$array1 = @()
$array1 += import-Csv "c:\temp\Updates.csv" 

   #Displays the data for user.

 " ________________________________________________________" | out-file -append c:\temp\test.txt
 "`n" | out-file -append c:\temp\test.txt
 "`n" | out-file -append c:\temp\test.txt

ForEach ($user in $array1)
{
$Username = $user.Clone
$Newuser = $user.Username
           
"***New Account Groups: $Newuser" | out-file -append c:\temp\test.txt
 $membership1 = get-adprincipalgroupmembership $newuser | select name | out-file -append c:\temp\test.txt
   $membership1 | out-file -append c:\temp\test.txt

"***Clone Account Groups: $Username" | out-file -append c:\temp\test.txt
 $membership = get-adprincipalgroupmembership $Username | select name | out-file -append c:\temp\test.txt
   $membership | out-file -append c:\temp\test.txt
"`n" | out-file -append c:\temp\test.txt
"`n" | out-file -append c:\temp\test.txt

}

$content = Get-Content c:\temp\test.txt
$content | Foreach {$_.TrimEnd()} | Set-Content c:\temp\test.txt









