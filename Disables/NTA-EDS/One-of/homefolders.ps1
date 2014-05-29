Remove-Item c:\temp\logs\one-of\homefolders.csv


$Folders = import-Csv "c:\temp\csv\one-of\updates.csv" 

ForEach ($Folder in $Folders) { 

#Retreive The user Account name, Home Directory and Copy to: Folder
$days = $Folder.ninetydaysahead
$name = $Folder.name
$path     



Get-Aduser $name -properties homedirectory | select samAccountName, homeDirectory | export-csv –append c:\temp\logs\homefolders.csv -NoTypeInformation 





 


}
C:\temp\logs\one-of\homefolders.csv



