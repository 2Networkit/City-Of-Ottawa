<################################################################################>
<##                                                                            ##>
<##                                 Groups.PS1                                 ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##            * Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##     This script opens user's AD record and pulls the groups its part of.   ##>
<##    It then displays the Marval call, the user's full name, the username,   ##>
<##  the supervisor name, The home share location, the date you do the disable ##>
<## the homefolder deleted date, the disabled folder path, the disabled folder ##> 
<##           deletetion date and the groups the account is part of.           ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<##                                                                            ##>
<################################################################################>

#Assigning path a to a variable names Hdrive
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create"

#Assigns date and format and variables
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\Groups\$date")
$Email = "$Hdrive\Email\CreateEmail3.txt"
$Logfile = "$Hdrive\logs\$dateonly\Groups\$date\groups.txt"
$clone = "c:\temp\Clone.csv"
$clone1 = "c:\temp\Clone1.csv"
$DiffGroups = "c:\temp\Diffgroups.csv"
$members = "c:\temp\Members.csv"
$membersof = "c:\temp\membersof.csv"
$membersof1 = "c:\temp\membersof1.csv"
$membersof2 = "$Hdrive\logs\$dateonly\Groups\$date\"
$Email = "$Hdrive\Email\CreateEmail4.txt"
$Groupresults =@()

#Creates new array.
$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv"

#specifies the OU to search in for groups.
$SearchBase = "OU=Distribution lists,OU=groups,DC=city,DC=a,DC=ottawa,DC=ca"
$arrayofgroups = Get-ADGroup -Filter * -SearchBase $SearchBase

#Searches for all groups in the OU except for the ones with this exception and adds them to a CSV database.
foreach ($item in $arrayofgroups) 
    {
        $group = $item.name
           Get-ADGroup -Identity $item -Properties * | 
           Where {$_.Info -notlike "Owner*"} |
           Where {$_.Info -notlike "M*Owner*"} |
           Where {$_.Info -notlike "Not Used*"} |
           Where {$_.Info -notlike "Restricted*"} |
           Where {$group -notlike "Exchange*"} | 
           Where {$group -notlike "GLCY*"} | 
           Where {$group -notlike "cGG Citrix*"} |
           Where {$group -notlike ">Employee Wellness Mailing"} | 
           Where {$group -notlike ">Benefits Mailing"} | 
           Where {$group -notlike "=PS*"} | 
           Where {$group -notlike "=People Services*"} | 
           Where {$group -notlike "cGGIClientservicesLimited_r"} |
           Where {$group -notlike "RAS Users"} | 
           Where {$group -notlike "*Boardroom"} |
           Where {$group -notlike "Networkusers"} | 
           Where {$group -notlike "CIPP*"} | 
           Where {$group -notlike "CUPE*"} | 
           Where {$group -notlike "MAPPINGS Y DRIVE"} | 
           Where {$group -notlike "MAPPINGS Y DRIVESAP"} | 
           Where {$group -notlike "Z_I*"} | 
           Where {$group -notlike "SAPR*"} | 
           Where {$group -notlike "CLGI*"} | 
           Where {$group -notlike "CGGS*"} | 
           Where {$group -notlike "CGGD*"} | 
           Where {$group -notlike "CGGW*"} | 
           Where {$group -notlike "CGGI*"} | 
           Where {$group -notlike "CGGR*"} | 
           Where {$group -notlike "PGM*"} | 
           Where {$group -notlike "TRAN PROJ"} | 
           Where {$group -notlike "OTX*"} | 
           Where {$group -notlike "cGG MgMt*"} | 
           Where {$group -notlike "+ Management*"} |
           Where {$group -notlike ">Benefits Inquiries"} |
           Where {$group -notlike "<Restricted*"} |
           Where {$group -notlike "=TUPW"} |
           Where {$group -notlike "cGG EMPTES"} |
           Where {$group -notlike "CMMP002 e-mail users"} |
           Where {$group -notlike "HR*"} |
           Where {$group -notlike "boardroom*"} |
           Where {$group -notlike ">C2C ArchiveOne Email Auto delete DC4"} |
           Where {$group -notlike ">C2C ArchiveOne Email Auto delete DC1"} |
           select @{n='Group';e={$group}} | Export-CSV -append "$membersof" –NoTypeInformation
     }

           #specifies the OU to search in for groups
           $SearchBase = "OU=Global Groups,OU=groups,DC=city,DC=a,DC=ottawa,DC=ca"
           $arrayofgroups = Get-ADGroup -Filter * -SearchBase $SearchBase

           #Searches for all groups in the OU except for the ones with this exception and appends them to the previous CSV database.
           foreach ($item in $arrayofgroups) 
               {
                   $group = $item.name
                     Get-ADGroup -Identity $item -Properties * | 
                     Where {$_.Info -notlike "Owner*"} |
                     Where {$_.Info -notlike "M*Owner*"} |
                     Where {$_.Info -notlike "Not Used*"} |
                     Where {$_.Info -notlike "Restricted*"} |
                     Where {$group -notlike "Exchange*"} | 
                     Where {$group -notlike "GLCY*"} |
                     Where {$group -notlike "cGG Citrix*"} |
                     Where {$group -notlike ">Employee Wellness Mailing"} | 
                     Where {$group -notlike ">Benefits Mailing"} | 
                     Where {$group -notlike "=PS*"} | 
                     Where {$group -notlike "=People Services*"} | 
                     Where {$group -notlike "cGGIClientservicesLimited_r"} |
                     Where {$group -notlike "RAS Users"} | 
                     Where {$group -notlike "*Boardroom"} |
                     Where {$group -notlike "Networkusers"} | 
                     Where {$group -notlike "CIPP*"} | 
                     Where {$group -notlike "CUPE*"} | 
                     Where {$group -notlike "MAPPINGS Y DRIVE"} | 
                     Where {$group -notlike "MAPPINGS Y DRIVESAP"} | 
                     Where {$group -notlike "Z_I*"} | 
                     Where {$group -notlike "SAPR*"} | 
                     Where {$group -notlike "CLGI*"} | 
                     Where {$group -notlike "CGGS*"} | 
                     Where {$group -notlike "CGGD*"} | 
                     Where {$group -notlike "CGGW*"} | 
                     Where {$group -notlike "CGGI*"} | 
                     Where {$group -notlike "CGGR*"} | 
                     Where {$group -notlike "PGM*"} | 
                     Where {$group -notlike "TRAN PROJ"} | 
                     Where {$group -notlike "OTX*"} | 
                     Where {$group -notlike "cGG MgMt*"} | 
                     Where {$group -notlike "+ Management*"} |
                     Where {$group -notlike ">Benefits Inquiries"} |
                     Where {$group -notlike "<Restricted*"} |
                     Where {$group -notlike "=TUPW"} |
                     Where {$group -notlike "cGG EMPTES"} |
                     Where {$group -notlike "CMMP002 e-mail users"} |
                     Where {$group -notlike "HR*"} |
                     Where {$group -notlike ">C2C ArchiveOne Email Auto delete DC4"} |
                     Where {$group -notlike ">C2C ArchiveOne Email Auto delete DC1"} |
                     select @{n='Group';e={$group}} | Export-CSV -append "$membersof" –NoTypeInformation

               }


                #Cleans out the CSV database file.
                (gc "$membersof") | % {$_ -replace '-----', ""} | ? {$_.trim() -ne "" } | out-file -append "$membersof1" -Fo -En ascii


                        #Prepares a CSV database from clone account and applies the groups not matching to the OU database and updating logfile.
                        ForEach ($user in $array)
                                   {
                                       $ErrorActionPreference= 'silentlycontinue'
                                       $Username = $user.Clone
                                       $Newuser = $user.Username
                                       $Exchange = $user.Attribute1
                                       $Exchangegroup = $user.EXCGroup
                                       $difference = @()
                                       $membership = @()


                                        " ________________________________________________________" | out-file -append $Logfile
                                        "`n" | out-file -append $Logfile
                                        "`n" | out-file -append $Logfile
                                       #Gets the user account's group membership before applying to the new member and adds to logfile.
                                       "***User: $Newuser" | out-file -append $Logfile
                                       "***Groups Before Adding Clone Account" | out-file -append $Logfile
                                       $membership1 = get-adprincipalgroupmembership $newuser | select name 
                                       $membership1 | out-file -append $Logfile

                                       #Gets the clone's account group membership before applying to the new member and adds to a new array.
                                       "***Clone Account: $Username" | out-file -append $Logfile
                                       "***Clone Account Groups" | out-file -append $Logfile
                                       $membership += get-adprincipalgroupmembership $Username | select name
                                       $membership | out-file -append $Logfile
                                       $membership.name | out-file -append "$clone" 
   
                                       #cleans the clone's created array and exports it to a new array
                                       $templist = (gc "$clone") | out-file -append "$clone1" -Fo -En ascii
                                       $content = $templist
                                       $content | Foreach {$_.TrimEnd()} | out-file -append "$clone1" 
   
                                       #Compares the clone database with the OU database and exports only the non matching groups to a new array.
                                       $base = get-content "$membersof1"
                                       $difference = get-content "$clone1" | where {$Base -match $_} 
                                       $difference | out-file -append "$DiffGroups"
   
                                           #Adds the compare array database of groups to the new account.
                                           ForEach ($Group in $Difference)
                                                      {
                                                          $Grouplist = get-adgroup $group
     
                                                             #Checks if the group is part the OU and adds the user to the group. Also adds user to the User Lockdown Group.
                                                             If ($grouplist.distinguishedname -eq  "CN=$group,OU=Distribution lists,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca")
                                                                    {
                                                                     Add-ADGroupMember  -identity "CN=$group,OU=Distribution lists,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca"  $newuser
                                                                     
                                                                    }
                                                                     
                                                                     else 
                                                                           #If the group was not part of the previous OU, it 
                                                                           {
                                                                            Add-ADGroupMember  -identity "CN=$group,OU=Global Groups,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser
                                                                             
                                                                           }
                                                      }

                                                             #Checks main Array for specific Exchange server user was created in and applies the proper group to the new user.
                                                             $Attrib = Get-ADUser $newuser -Properties * | select extensionAttribute1
                                                             If ($attrib -ne "DC1" -or $attrib -ne "DC4")
                
                                                                    {
                                                                     Add-ADGroupMember  -identity "CN=$exchangegroup,OU=Distribution lists,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca" -member $newuser
                
                                                                    }

                                                             #Adds the "cGG GPO User Lockdown Settings" group to all users.
                                                             Add-ADGroupMember  -identity "CN=cGG GPO User Lockdown Settings,OU=GPO Groups,OU=Groups,DC=city,DC=a,DC=ottawa,DC=ca"  $newuser

                                     #Gets the user account's group membership after applying the clone groups and adds to logfile.
                                       "***User: $Newuser" | out-file -append $Logfile
                                       "***Groups After Cloning Account" | out-file -append $Logfile
                                       $membership2 = get-adprincipalgroupmembership $newuser | select name 
                                       $membership2 | out-file -append $Logfile
                
   
Remove-item "$DiffGroups"
Remove-Item "$clone"
Remove-Item "$clone1" 
                                            
    
                                   }
   
copy-item "$membersof" "$membersof2"
Remove-Item "$membersof"
Remove-Item "$membersof1"

#Creates link to ApplyGroups log in email file      
"$logfile" | out-file -append $Email

$content = Get-Content $Logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $Logfile
#start excel "$logfile"