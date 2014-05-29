
$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv"

ForEach ($user in $array)
{
$ErrorActionPreference= 'silentlycontinue'
$Username = $user.Clone
$Newuser = $user.Username
$Exchange = $user.Attribute1
$Exchangegroup = $user.EXCGroup


   $membership = get-adprincipalgroupmembership $Username | select name | out-file -append $clone
   

$templist = (gc $clone) | % {$_ -replace '----', ""} | ? {$_.trim() -ne "" } 
$content = $templist
   $content | Foreach {$_.TrimEnd()} | Set-Content $clone1
   Remove-Item $clone




$base = get-content $membersof1
get-content $clone1 | where {$base -match $_} | out-file -append $DiffGroups
(gc $DiffGroups) | % {$_ -replace '-----', ""} |  % {$_ -replace 'Group', ""} |? {$_.trim() -ne "" } | out-file -append $DiffGroups
   $content = Get-Content $DiffGroups
   $content | Foreach {$_.TrimEnd()} | Set-Content $DiffGroups
 


   $Difference = @(Import-Csv $DiffGroups)
   ForEach ($Groups in $Difference)
   {
   $Group = $Groups.name

   
   Add-ADGroupMember  -identity "CN=$group,OU=Distribution lists,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser 
   Add-ADGroupMember  -identity "CN=$group,OU=Global Groups,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser

   if ($Exchange -eq "DC1" -or $Exchange -eq "DC4")
                
                {
                     Add-ADGroupMember  -identity "CN=$exchangegroup,OU=Distribution lists,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser
                
                }
                else
                        {                           
                        }
                        Remove-Item $membersof
                        Remove-Item $membersof1
                        Remove-Item$DiffGroups
   }
   }