import-Csv 'c:\temp\CSV\one-of\updates.csv' | ForEach-Object {
{
}
write-output "***Username: " $_.name
write-output "***Full Name: " $_.fullname 
     ROBOCOPY $_.homedirectory $_.Disabledfolderpath /z /e /v /copyall /eta /r:1 /w:0 >> "c:\temp\logs\one-of\Robocopy.txt"
{
}
{
}
{
}
}
