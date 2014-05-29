$Groupname = Get-ADGroup -filter * -properties info,Name |Select-Object -ExpandProperty name,info | out-file -append c:\temp\test.csv

$Groupname1 = Get-ADGroup -filter * -properties info |Format-Table -Property info 

$comma = ","

$groupname += $comma +=$Groupname1 | out-file -append c:\temp\test.csv


# Using $a | Foreach-Object {} | Export-Csv
$Groupname | ForEach-Object { 
    New-Object PSObject -Property $_.name 
} | out-file -append  c:\temp\test.csv




 "$groupname't$Groupname1" out-file -append c:\temp\test.csv
