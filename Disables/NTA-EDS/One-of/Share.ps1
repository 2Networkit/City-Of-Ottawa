$Folders = import-Csv "c:\temp\csv\one-of\updates.csv"
 
ForEach ($Folder in $Folders) {

$command = $Folder.ServerUNC + 'root\cimv2:Win32_Share="' + $Folder.Sharename + '"'
 
([wmi]$command).Delete()
#([wmi]'\\cmfp043\root\cimv2:Win32_Share="Marc$"').Delete()
 
}
