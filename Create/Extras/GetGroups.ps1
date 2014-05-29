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
$Membersof = "$Hdrive\logs\$dateonly\Groups\$date\Membersof.csv"
$Clonegroups = "$Hdrive\logs\$dateonly\Groups\$date\Clonegroups.csv"
$Difference = "$Hdrive\logs\$dateonly\Groups\$date\Diff.csv"
$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv" 

$Username = $user.Username
$Clone = $user.Clone

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
    select @{n='Group';e={$group}}, @{n='Description';e={$_.description}}, @{n='Info';e={$_.Info}} | Export-CSV -append $membersof –NoTypeInformation
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
    select @{n='Group';e={$group}}, @{n='Description';e={$_.description}}, @{n='Info';e={$_.Info}} | Export-CSV -append $membersof –NoTypeInformation
}

$List = $membersof | select * -ExcludeProperty Description,Info 


ForEach ($user in $array)
{


#Displays the data for user.

 " ________________________________________________________" | out-file -append $logfile

           
"***Clone Username: $Clone" | out-file -append $logfile

#Gets the groups membership for the user account.
   
"***Groups:" | out-file -append $logfile

   $membership =     get-adprincipalgroupmembership $Clone | select name
   $membership | out-file -append $CloneGroups
   $CloneGroups | out-file -append $logfile


"Groups to be added from Clone to User" | out-file -append $logfile

$base = $List
$Membership |
where {$base -match $_} |
out-file -append $Difference
(gc $Difference) | % {$_ -replace '-----', ""} | ? {$_.trim() -ne "" } | out-file $Difference -Fo -En ascii
   $content = Get-Content $Difference
   $content | Foreach {$_.TrimEnd()} | Set-Content $Difference | out-file -append $logfile

   $user = Get-ADUser -Identity $Username -Properties MemberOf

# Remove all group memberships (will leave Domain Users as this is NOT in the MemberOf property returned by Get-ADUser)

    foreach ($group in $Difference)
	{
		Set-ADGroupMember -Identity $group -Members $username -Confirm:$false
}

}


 


   #Opens the log file to show the data.
#$content = Get-Content $logfile
#$content | Foreach {$_.TrimEnd()} | Set-Content $logfile




















# Retrieve the user object and MemberOf property

	$user = Get-ADUser -Identity $Username -Properties MemberOf

# Remove all group memberships (will leave Domain Users as this is NOT in the MemberOf property returned by Get-ADUser)
foreach ($group in ($user | Select-Object -ExpandProperty MemberOf))
	{
		Set-ADGroupMember -Identity $group -Members $username -Confirm:$false
}

Remove-Item 'C:\temp\membersof.csv'

