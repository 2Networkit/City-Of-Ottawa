Write-Output "The Exchange Script Took This Much Time To Complete:"
measure-command {PowerShell.exe -command ". 'D:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto; C:\temp\scripts\Exchange.ps1"}
{
}
Write-Output "The ADM Account Search Script Took This Much Time To Complete:"
Measure-Command {c:\temp\scripts\admaccounts.ps1}
{
}
Write-Output "The Groups Script Took This Much Time To Complete:"
Measure-Command {c:\temp\scripts\groups.ps1}
{
}
Write-Output "The Create Disabled Directory Creation Script Took This Much Time To Complete:"
Measure-Command {c:\temp\scripts\RemoteDirectory.ps1}
{
}
Write-Output "The Robocopy Script Took This Much Time To Complete:"
Measure-Command {c:\temp\scripts\robocopy.ps1}
{
}
Write-Output "Disable Scripts done!"