$Mailboxname = (Get-Recipient -Resultsize unlimited | ft Name)
$Mailboxtype = (Get-Recipient -Resultsize unlimited | ft RecipienttypeDetails)

$o = new-object PSObject
$o | add-member NoteProperty Name $mailboxName
$o | add-member NoteProperty HomeDirectory $MailboxType
$o | export-csv -append "c:\temp\shared.csv" -notypeinformation