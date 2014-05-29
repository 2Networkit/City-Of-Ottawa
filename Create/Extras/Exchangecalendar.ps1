$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\create"
$array1 = @()
$array1 += import-Csv "$Hdrive\CSV\Updates.csv" 



ForEach ($user in $array1) 
{

$username = $user.username

Get-Mailbox -Identity $Username | Set-CalendarProcessing -ProcessExternalMeetingMessages $True
}