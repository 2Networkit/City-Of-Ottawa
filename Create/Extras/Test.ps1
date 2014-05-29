$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create"
$DiffGroups = "$Hdrive\logs\05-06-2014\Groups\05-06-2014_12-24-31\Diffgroups.csv"
$clone1 = "$Hdrive\logs\05-06-2014\Groups\05-06-2014_12-24-31\Clone1.csv"
$clone = "$Hdrive\logs\05-06-2014\Groups\05-06-2014_12-24-31\Clone.csv"
$clone1 = "$Hdrive\logs\05-06-2014\Groups\05-06-2014_12-24-31\Clone1.csv"
$members = "$Hdrive\logs\05-06-2014\Groups\05-06-2014_12-24-31\Members.csv"
$membersof1 = "$Hdrive\logs\05-06-2014\Groups\05-06-2014_12-24-31\Membersof1.csv"





Import-Csv $members | select * -ExcludeProperty Description,Info | Export-CSV -append $membersof1 –NoTypeInformation



$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv"


ForEach ($user in $array)
{
$ErrorActionPreference= 'silentlycontinue'
$Username = $user.Clone
$Newuser = $user.Username
$Exchange = $user.Attribute1
$Exchangegroup = $user.EXCGroup


get-adprincipalgroupmembership $Username | select name | out-file -append $clone1
   

$templist = (gc $clone1) | % {$_ -replace '----', ""} | ? {$_.trim() -ne "" } 
$content = $templist
   $content | Foreach {$_.TrimEnd()} | Set-Content $clone1
   
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
                                              
    }
   Remove-Item$DiffGroups
   }


Remove-Item $membersof
Remove-Item $membersof1
                        
 


$array1 = @()
$array1 += import-Csv "$Hdrive\CSV\Updates.csv"  

   #Displays the data for user.

 " ________________________________________________________" | out-file -append $Logfile
 "`n" | out-file -append $Logfile
 "`n" | out-file -append $Logfile

ForEach ($user in $array1)
{
$Username = $user.Clone
$Newuser = $user.Username
           
"***New Account Groups: $Newuser" | out-file -append $Logfile
 $membership1 = get-adprincipalgroupmembership $newuser | select name | out-file -append $Logfile
   $membership1 | out-file -append $Logfile

"***Clone Account Groups: $Username" | out-file -append $Logfile
 $membership = get-adprincipalgroupmembership $Username | select name | out-file -append $Logfile
   $membership | out-file -append $Logfile
"`n" | out-file -append $Logfile
"`n" | out-file -append $Logfile

}
Remove-Item $clone1

$content = Get-Content $Logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $Logfile

