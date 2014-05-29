<################################################################################>
<##                                                                            ##>
<##     This scriptv sends the final email with links to all the log files.    ##>
<##                                                                            ##>
<################################################################################>


#Build the body of the email with links to all the log files.
$array = @()
$array += import-Csv \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\CSV\Updates.csv
 
ForEach ($user in $array)
 
{
$Attrib = ", "
$username = $user.username 

"$username$Attrib" | out-file -append '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\createemail.txt'
}

$mainmessage = "New Account / Re-enable script has run and successfully completed" + "`r`n" 
$Header = "Your logs can be accessed at the following links:" + "`r`n"
$Usermessage = "Accounts created or re-enabled for the following users:" + "`r`n"
$Users = get-content '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\createemail.txt'
$Exchange = "You can run your Exchange report from this link:" + "`r`n"
$Message7 = get-content '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\createemail7.txt'
$Space = "" + "`r`n" 
$Homefolders = "Homefolder Logs:" + "`r`n"
$Message1 = get-content '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\createemail1.txt'
$ADCredentials = "ADCredentials Logs:" + "`r`n"
$Message2 = get-content '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\createemail2.txt'
$CreateHomeShare = "CreateHomeShare" + "`r`n"
$Message3 = get-content '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\createemail3.txt'
$Groups = "Groups Logs:" + "`r`n"
$Message4 = get-content '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\createemail4.txt'
$ExchangeCalendar = "ExchangeCalendar Logs:" + "`r`n"
$Message5 = get-content '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\createemail5.txt'
$FullLog = "FullLog:" + "`r`n"
$Message6 = get-content '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\createemail6.txt'
$Solution = "You can run your solution report from this link:" + "`r`n"
$Message = '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\scripts\solution.ps1'
$reruncalendar = "You can run re-run your Calendar script from this link if the last run had errors:" + "`r`n"
$Message1 = '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\scripts\exchangecalendar.ps1'
$Thanks = "Thank You"
$messagebody = $messagebody + $mainmessage + "`r`n" + $Usermessage + "`r`n" + $Users + "`r`n" + $header + "`r`n" + $Exchange + "`r`n" + $Space + "`r`n" + $Message7 + "`r`n" + $Space + "`r`n" + $Space + "`r`n" + $HomeFolders + "`r`n" + $Message1 + "`r`n" + $ADCredentials + "`r`n" + $Message2 + "`r`n" + $CreateHomeShare + "`r`n" + $Message3 + "`r`n" + $Groups + "`r`n" + $Message4 + "`r`n" + $ExchangeCalendar + "`r`n" + $Message5 + "`r`n" + $Space + "`r`n" + $FullLog + "`r`n" + $Message6 + "`r`n" + $Space + "`r`n" + $Space + "`r`n" + $Solution + "`r`n" + $Message + "`r`n" + $Space + "`r`n" + $reruncalendar + "`r`n" + $Message1 + "`r`n" + $Space + "`r`n" + $Space + "`r`n" + $Thanks

#Function that generates the email
function sendMail{

     Write-Host "Sending Log Email"
     
     #SMTP server name
     $smtpServer = "appsmtp.ottawa.ca"

     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage

     #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)

     #Email structure 
     $msg.From = "ntadmins@ottawa.ca"
     $msg.ReplyTo = "ntadmins@ottawa.ca"
     $msg.To.Add("ntadmins@ottawa.ca")
     $msg.subject = "Account creation / re-enabled Completed"
     $msg.body = $messagebody


     #Sending email 
     $smtp.Send($msg)
  
}

#Calling function
sendMail

#Removes all files from the email folder
Remove-Item '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Email\*.*'
