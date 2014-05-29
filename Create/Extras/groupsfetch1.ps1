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
$Username = $user.username

#Displays the data for user.

 " ________________________________________________________" | out-file -append $logfile

           
"***Username: $Username" | out-file -append $logfile

#Gets the groups membership for the user account.
   
"***Groups:" | out-file -append $logfile

   $membership =     get-adprincipalgroupmembership $Username | select name
   $membership | out-file -append $logfile



}

#Opens the log file to show the data.
$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile
start notepad $Logfile