#This script will prompt user to choose his name or Contractor if he's not an employee part of the list and then start the proper solution log.

$Ron = New-Object System.Management.Automation.Host.ChoiceDescription "&Ron",""
$Suzanne = New-Object System.Management.Automation.Host.ChoiceDescription "&Suzanne",""
$Lily = New-Object System.Management.Automation.Host.ChoiceDescription "&Lily",""
$Emily = New-Object System.Management.Automation.Host.ChoiceDescription "&Emily",""
$Contractor = New-Object System.Management.Automation.Host.ChoiceDescription "&Contractor",""
$choices = [System.Management.Automation.Host.ChoiceDescription[]]($Ron,$Suzanne,$Lily,$Emily,$Contractor)
$caption = "Warning!"
$message = "Please select yourself from the list"
$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
if($result -eq 0) { Write-Host "You answered Ron Guilbeaut"
Invoke-Expression \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\RonSolution.ps1}
if($result -eq 1) { Write-Host "You answered Suzanne Groulx"
Invoke-Expression \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\SueSolution.ps1 }
if($result -eq 2) { Write-Host "You answered Lily Ho"
Invoke-Expression \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\LilySolution.ps1}
if($result -eq 3) { Write-Host "You answered Emily Yu, Sy-Wei" 
Invoke-Expression \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\EmilySolution.ps1}
if($result -eq 4) { Write-Host "You answered temp Contractor, Temp Contractor" 
Invoke-Expression \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\Contractorsolution.ps1}