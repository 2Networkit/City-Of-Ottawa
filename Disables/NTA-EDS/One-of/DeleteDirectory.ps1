import-Csv "c:\temp\csv\one-of\updates.csv" | ForEach-Object {

$Server = $_.ServerUNC
$Username = $_.name
$middle = 'e$\usr\'
$middle2 = 'f$\usr\'
Remove-Item -Recurse -Force "$Server$middle$UserName" 
Remove-Item -Recurse -Force "$Server$middle2$UserName" 
   
}