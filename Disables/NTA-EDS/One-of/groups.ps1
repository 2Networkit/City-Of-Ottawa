start-transcript -path "c:\temp\logs\one-of\Groups.txt"


import-Csv "c:\temp\csv\one-of\updates.csv" | ForEach-Object {


#Retreive The user group membership

    Write-output ________________________________________________________

{
}
    write-output "***Marval #: " $_.Marval

    write-output "***Full Name: " $_.fullname 
            
    write-output "***Username: " $_.name

    Write-Output "***Supervisor: " $_.Supervisor

    Write-Output "***Previous Home Share Location: " $_.homeDirectory

    Write-output "***Disabled date: "$_.date

    Write-Output "***Disabled home folder path: " $_.Disabledfolderpath

    Write-output "***Homefolder deletion date: "$_.ninetydaysahead

    Write-output "***Groups:"
        get-adprincipalgroupmembership $_.name | select name

# Retrieve the user object and MemberOf property
	$user = Get-ADUser -Identity $_.name -Properties MemberOf 
    
# Remove all group memberships (will leave Domain Users as this is NOT in the MemberOf property returned by Get-ADUser)
    foreach ($group in ($user | Select-Object -ExpandProperty MemberOf))
	{


		Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
	}

{
}

}
Write-Output "Groups.ps1 done!"
stop-transcript
C:\temp\logs\one-of\groups.txt