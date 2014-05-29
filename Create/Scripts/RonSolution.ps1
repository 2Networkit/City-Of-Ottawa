<################################################################################>
<##                                                                            ##>
<##                               RonSolution.PS1                              ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##     This script creates a log for the solution step in Marval and EDS      ##>
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
Mkdir ($Hdrive+"\Logs\$dateonly\Solution\$date")
$Logfile = "$Hdrive\logs\$dateonly\Solution\$date\Solution.txt"


$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv"
 
ForEach ($user in $array)
    {

        $clone = $User.clone
        $Fullname = $user.name
        $Username = $user.username
        $Password = $User.password
        $Primary = $user.primaryemail
        $Secondary = $User.secondaryemail
        $SharedDrive = $User.SDrive


        #Outputs to the logfile the solution data for user.
        " ________________________________________________________" | out-file -append $logfile
        "`n" | out-file -append $logfile
        "`n" | out-file -append $logfile
        "The network and email account has been completed and/or reconfigured for:" | out-file -append $logfile
        "`n" | out-file -append $logfile
        "Employee Name: $Fullname"  | out-file -append $logfile
        "Account to clone: $Clone"  | out-file -append $logfile
        "Logon ID: $Username" | out-file -append $logfile
        "Password: $password" | out-file -append $logfile
        "E-mail Address: $Primary" | out-file -append $logfile
        "Secondary E-mail Address: $secondary" | out-file -append $logfile
        "`n" | out-file -append $logfile
        "`n" | out-file -append $logfile
        "Shared Drive: $SharedDrive" | out-file -append $logfile
        "`n" | out-file -append $logfile
        "`n" | out-file -append $logfile
        "If access to specific applications 7(e.g. SAP, MAP, etc.) is required please send an e-mail to ServDeskCorp@ottawa.ca with the subject line OPEN CALL." | out-file -append $logfile
        "`n" | out-file -append $logfile
        "Please have the employee update their phone, mail delivery, and location using 'City Intranet | Employee Directory | Update' http://ozonehome.city.a.ottawa.ca/irj/portal/coo_empdir" | out-file -append $logfile
        "`n" | out-file -append $logfile
        "Ron Guilbeault " | out-file -append $logfile
        "Service Desk Analyst 2 | Analyste 2,  Centre de dépannage" | out-file -append $logfile
        "Tel. | 613-580-2424 ext.| poste 13215" | out-file -append $logfile
        "Fax | téléc. 613-580-2446" | out-file -append $logfile
        "Email | Courriel: Ron.Guilbeault@ottawa.ca" | out-file -append $logfile
        "You don't stop Laughing because you grow old: You grow old because you stop Laughing" | out-file -append $logfile
        "`n" | out-file -append $logfile
        "`n" | out-file -append $logfile


    }



#Opens the log file to show the data.
$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile
start notepad $Logfile