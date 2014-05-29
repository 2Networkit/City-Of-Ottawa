

$csv = 'c:\temp\Updates.csv'
(Get-Content $CSV) | Where-Object {$_ -notmatch ",,,,,,,,,"} |sc "c:\temp\Updates.csv"


