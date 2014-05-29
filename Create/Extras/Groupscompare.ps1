$SearchBase = "OU=Global Groups,OU=groups,DC=city,DC=a,DC=ottawa,DC=ca"
$arrayofgroups = Get-ADGroup -Filter * -SearchBase $SearchBase

foreach ($item in $arrayofgroups) {
$group = $item.name
    Get-ADGroup -Identity $item -Properties * |
    select @{n='Samaccountname';e={$_.samaccountname}}, @{n='Name';e={$_.CN}} | Export-CSV -append 'C:\temp\groupscompare.csv' –NoTypeInformation
    }


   $content = Get-Content c:\temp\groupscompare.csv
   $content | Foreach {$_.TrimEnd()} | Set-Content c:\temp\groupscompare.csv
   $content = Get-Content c:\temp\groupscompare1.csv
   $content | Foreach {$_.TrimEnd()} | Set-Content c:\temp\groupscompare1.csv
    $base = get-content c:\temp\groupscompare.csv
get-content C:\temp\groupscompare1.csv | where {$base -match $_} | out-file -append c:\temp\groupsdiff.csv