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
Mkdir ($Hdrive+"\Logs\$dateonly\A-ADMGroups\$date")
$Logfile = "$Hdrive\logs\$dateonly\A-ADMGroups\$date\A-ADMGroups.txt"



$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv" 
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
            
"***Username: $Username" | out-file -append $logfile


#Gets the groups membership for the user account.
   
"***Groups:" | out-file -append $logfile

   $membership =     get-adprincipalgroupmembership $Username -server a.ottawa.ca | select name
   $membership | out-file -append $logfile

	
}

#Opens the log file to show the data.
$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile
start notepad $Logfile