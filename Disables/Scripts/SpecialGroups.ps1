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
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Disables"

#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\SpecialGroups\$date")
$Logfile = "$Hdrive\logs\$dateonly\SpecialGroups\$date\SpecialGroups.txt"



$array = @()
$array += import-Csv "$Hdrive\CSV\PurgeUpdates.csv" 
ForEach ($user in $array)
{

$Marval = $User.Marval
$Fullname = $user.fullname
$Username = $user.name
$Supervisor = $User.supervisor
$Homefolderpath = $user.homeDirectory
$Homesstatus = $User.homefolderstatus
$todaysdate = $User.date
$Folderpath = $User.Disabledfolderpath
$daysahead = $User.ninetydaysahead
$Status = $user.accountstatus

#Displays the data for user.

 " ________________________________________________________" | out-file -append $logfile


"***Marval #: $Marval" | out-file -append $logfile

"***Full Name: $fullname" | out-file -append $logfile
            
"***Username: $Username" | out-file -append $logfile

"***Account Status: $Status" | out-file -append $logfile

"***Supervisor: $Supervisor" | out-file -append $logfile

"***Previous homefolder Location: $homefolderpath" | out-file -append $logfile

"***Homefolder Status: $homesstatus" | out-file -append $logfile

"***Disabled date: $Todaysdate" | out-file -append $logfile

"***HomeFolder deleted date: $Todaysdate" | out-file -append $logfile

"***Disabled homefolder path: $Folderpath" | out-file -append $logfile

"***Disabled folder deletion date: $daysahead" | out-file -append $logfile

#Gets the groups membership for the user account.
   
"***Groups:" | out-file -append $logfile

   $membership =     get-adprincipalgroupmembership $Username | select name
   $membership | out-file -append $logfile

# Retrieve the user object and MemberOf property

	$user = Get-ADUser -Identity $Username -Properties MemberOf

# Remove all group memberships (will leave Domain Users as this is NOT in the MemberOf property returned by Get-ADUser)

    foreach ($group in ($user | Select-Object -ExpandProperty MemberOf))
	{
		Remove-ADGroupMember -Identity $group -Members $username -Confirm:$false
}
#Removes the Home Folder settings.

        Set-ADUser $username -HomeDirectory $null -homedrive $null
        "***Removed Home Folder Path"  | out-file -append $logfile	

}

#Opens the log file to show the data.
$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile
start notepad $Logfile