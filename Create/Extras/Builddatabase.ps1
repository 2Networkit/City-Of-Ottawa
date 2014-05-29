<################################################################################>
<##                                                                            ##>
<##                              Builddatabase.PS1                             ##>
<##                                                                            ##>
<##                                 Written by:                                ##>
<##              Marc Villeneuve (marcvilleneuve@2networkit.com)               ##>
<##                                                                            ##>
<##  This script populates a csv database and then runs all scripts to create  ##>
<##              a new account or re-enable a disabled account                 ##>
<##                                                                            ##>
<##                  This script was created using POWERSHELL ISE              ##>
<##                                                                            ##>
<################################################################################>




#Imports module to make AD available in a Exchange Powershell window
import-module activedirectory

#Creates a Buffer file of the Daily Reports and the Updates XLSX on the local temp directory and removes the read only attribute to the Updates.xlsx file
Copy-Item \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\CSV\Updates.xlsx c:\temp\
Copy-Item '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\DailyReports\New Accounts EDS.xlsx' c:\temp\
sp c:\temp\updates.xlsx IsReadOnly $false


#This function mkes it possible to import a excel file in powershell
function Import-Excel
{
  param (
    [string]$FileName,
    [string]$WorksheetName,
    [bool]$DisplayProgress = $true
  )

  if ($FileName -eq "") {
    throw "C:\temp\New Accounts EDS.xlsx"
    Exit
  }

  if (-not (Test-Path $FileName)) {
    throw "Path '$FileName' does not exist."
    exit
  }

  $FileName = Resolve-Path $FileName
  $excel = New-Object -com "Excel.Application"
  $excel.Visible = $false
  $workbook = $excel.workbooks.open($FileName)

  if (-not $WorksheetName) {
    Write-Warning "Defaulting to the first worksheet in workbook."
    $sheet = $workbook.ActiveSheet
  } else {
    $sheet = $workbook.Sheets.Item($WorksheetName)
  }
  
  if (-not $sheet)
  {
    throw "Unable to open worksheet $WorksheetName"
    exit
  }
  
  $sheetName = $sheet.Name
  $columns = $sheet.UsedRange.Columns.Count
  $lines = $sheet.UsedRange.Rows.Count
  
  Write-Warning "Worksheet $sheetName contains $columns columns and $lines lines of data"
  
  $fields = @()
  
  for ($column = 1; $column -le $columns; $column ++) {
    $fieldName = $sheet.Cells.Item.Invoke(1, $column).Value2
    if ($fieldName -eq $null) {
      $fieldName = "Column" + $column.ToString()
    }
    $fields += $fieldName
  }
  
  $line = 3
  
  
  for ($line = 3; $line -le $lines; $line ++) {
    $values = New-Object object[] $columns
    for ($column = 1; $column -le $columns; $column++) {
      $values[$column - 1] = $sheet.Cells.Item.Invoke($line, $column).Value2
    }  
  
    $row = New-Object psobject
    $fields | foreach-object -begin {$i = 0} -process {
      $row | Add-Member -MemberType noteproperty -Name $fields[$i] -Value $values[$i]; $i++
    }
    $row
    $percents = [math]::round((($line/$lines) * 100), 0)
    if ($DisplayProgress) {
      Write-Progress -Activity:"Importing from Excel file $FileName" -Status:"Imported $line of total $lines lines ($percents%)" -PercentComplete:$percents
    }
  }
  $workbook.Close()
  $excel.Quit()
  Stop-Process -processname excel
}



#loads the New Account EDS.xlsx file, removes the autocreated header and saves a copy in CSV format
$reportLines = Import-Excel 'C:\temp\New Accounts EDS.xlsx'
$tmp = "C:\temp\updates.xlsx"
$savePath = $tmp -replace ".xl\w*$",".csv"
$reportlines | export-csv c:\temp\test.csv -Encoding ascii -NoTypeInformation
$test = @()
$test += import-csv "c:\temp\test.csv" | select -skip 1


#cleans the temporary csv file and removes all occurence of the word Total:
(gc "c:\temp\test.csv" | select -Skip 1) | sc "c:\temp\test.csv"
(gc "c:\temp\test.csv") | Where-Object {$_ -notmatch 'Total:'} | sc "c:\temp\test.csv"

#cleans the temporary csv file and removes all occurence of the -=- characters
$csv = 'c:\temp\test.csv'
(Get-Content $csv) -replace '-=-' , "" | Set-Content $csv


#populates the main xlsx with the data from the Dailyreport file
$csvFile = "C:\temp\test.csv" 
$path = "C:\temp\updates.xlsx" 
$processes = Import-Csv -Path $csvFile 
$Excel = New-Object -ComObject excel.application 
$Excel.visible = $true
$excel.DisplayAlerts = $false 
$excel.ScreenUpdating = $True 
$excel.UserControl = $false 
$excel.Interactive = $false
$workbook = $Excel.workbooks.open($path) 
$i = 2 
foreach($process in $processes) 
{ 
 $excel.cells.item($i,1) = $process."Reference no" 
 $excel.cells.item($i,2) = $process."Customer Name" 
 $excel.cells.item($i,3) = $process."Customer Altkey ID" 
 $excel.cells.item($i,4) = $process."History Notes"

 $i++ 
} #end foreach process 

#Saves the XLSX and also a CSV file
$workbook.save() 
$workbook.SaveAs($Savepath,6) 
$Workbook.Close() 
$Excel.Quit() 
Remove-Variable -Name excel
Stop-Process -processname excel 
[gc]::collect() 
[gc]::WaitForPendingFinalizers()

<################################################################################>
<##                                                                            ##>
<##                         Calls the CleanCSV Script                          ##>
<##                                                                            ##>
<################################################################################>

Write-Host "Starting CleanCSV Script"

Invoke-Expression 'powershell -version 3 \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\Cleancsv.ps1'

Write-Host "Completed CleanCSV Script"

Write-Host ""
Write-Host ""

<################################################################################>
<##                                                                            ##>
<##                        Calls the Homefolder Script                         ##>
<##                                                                            ##>
<################################################################################>

Write-Host "Starting HomeFolder Script"

Invoke-Expression 'powershell -version 3 \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\Homefolders.ps1'

Write-Host "Completed HomeFolder Script"

Write-Host ""
Write-Host ""

#populates the main xlsx with the data gathered in the Homefolder script
$tmp = "C:\temp\updates.xlsx"
$savePath = $tmp -replace ".xl\w*$",".csv"
$csvFile = "c:\temp\Homefolders.csv"
$path = "C:\temp\updates.xlsx" 
$processes = Import-Csv -Path $csvFile 
$Excel = New-Object -ComObject excel.application 
$Excel.visible = $true
$excel.DisplayAlerts = $false 
$excel.ScreenUpdating = $True 
$excel.UserControl = $false 
$excel.Interactive = $false
$workbook = $Excel.workbooks.open($path) 
$i = 2 
foreach($process in $processes) 
{ 
 $excel.cells.item($i,5) = $process."HomeDirectory" 
 $i++ 
} #end foreach process 

#Saves the XLSX and also a CSV file
$workbook.save() 
$workbook.SaveAs($Savepath,6) 
$Workbook.Close() 
$Excel.Quit() 
Remove-Variable -Name excel
Stop-Process -processname excel 
[gc]::collect() 
[gc]::WaitForPendingFinalizers()

<################################################################################>
<##                                                                            ##>
<##                         Calls the CleanCSV Script                          ##>
<##                                                                            ##>
<################################################################################>

Write-Host "Starting CleanCSV Script"

Invoke-Expression \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\Cleancsv.ps1

Write-Host "Completed CleanCSV Script"

Write-Host ""
Write-Host ""

Copy-Item c:\temp\Updates.csv \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\csv\
 
#Starts the Updates.csv file to check if all has populated correctly
start excel "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\CSV\Updates.csv"

#Need user action to continue or stop script
Read-Host 'Press Enter twice if data is ok or Ctrl C if you need to stop this script' | Out-Null
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,AllowCtrlC")

#Copies the Updated.csv file to the proper location for other scripts to run
Copy-Item c:\temp\Updates.csv '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\CSV\'

#removes all buffer files created on temp folder & also in the DailyReports folder
Remove-Item C:\temp\Homefolders.csv
Remove-item c:\temp\Test.csv
Remove-item c:\temp\updates.xlsx
Remove-item 'c:\temp\New Accounts EDS.xlsx'
Remove-Item c:\temp\updates.csv
Remove-Item '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\DailyReports\New Accounts EDS.xlsx'

<################################################################################>
<##                                                                            ##>
<##                     Calls the Homedirectory Script                         ##>
<##                                                                            ##>
<################################################################################>

Write-Host "Starting HomeDirectory Script"

Invoke-Expression 'powershell -version 3 \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\Homedirectory.ps1'

Write-Host "Completed HomeDirectory Script"

Write-Host ""
Write-Host ""

<################################################################################>
<##                                                                            ##>
<##                   Calls the Createhomeshare Script                         ##>
<##                                                                            ##>
<################################################################################>

Write-Host "Starting CreateHomeShare Script"

Invoke-Expression 'powershell -version 3 \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\Createhomeshare.ps1'

Write-Host "Completed CreateHomeShare Script"

Write-Host ""
Write-Host ""

<################################################################################>
<##                                                                            ##>
<##                      Calls the Applygroups Script                          ##>
<##                                                                            ##>
<################################################################################>

Write-Host "Starting ApplyGroups Script"

Invoke-Expression 'powershell -version 3 \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\Applygroups.ps1'

Write-Host "Completed ApplyGroups Script"

Write-Host ""
Write-Host ""


<################################################################################>
<##  This script creates a new user mailbox or re-enables a disabled mailbox.  ##>
<##  Gets actuall settings if disabled then changes those settings to reflect  ##>
<##                            the enable procedure.                           ##>
<##     The whole actual and changed settings are exported to a TXT file       ##>
<################################################################################>

#setting powershell window size
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 300
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 132
$pswindow.windowsize = $newsize

#Assigning path a to a variable names Hdrive
$Hdrive = "\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\create"

#Assigns date and format 
$date = get-date -f MM-dd-yyyy_HH-mm-ss
$dateonly = get-date -f MM-dd-yyyy
Mkdir ($Hdrive+"\Logs\$dateonly\Exchange\$date")
$Logfile = "$Hdrive\logs\$dateonly\Exchange\$date\Exchange.txt"
$reportFile = "$Hdrive\logs\$dateonly\CSVFileUsed\$date\"

#Command to not show errors on powershell window.
$ErrorActionPreference= 'silentlycontinue'

#Imports data file.
$array = @()
$array += import-Csv "$Hdrive\CSV\Updates.csv" 


#Start of loop to set exchange settings to new account or existing one.
ForEach ($user in $array)
 
{
$username = $user.username
$Email = $User.ADEmail
$RFAX = $user.RFax

    #Checks if mailbox already exists on Exchange Server
    if (-not (Get-Mailbox -identity $username))

        {
          $Database = $User.EmailDatabase
          $newattribute1 = $user.attribute1
          $newattribute8 = $user.attribute8
          $newattribute10 = $user.attribute10
          $Warning = [String]$user.warnings+'MB'
          $Sendquota = [String]$user.quota+'MB'
          $Defaults = $user.defaults
          $Email1 = $user.PrimaryEmail
          $Email2 = $user.SecondaryEmail
          $RFAX = $user.RFax
          $x400 = $user.X400
          $Firstname = $user.Firstname
          $Lastname = $user.Lastname
          $Middlename = $user.Initial
          
          

          "Creating Account $username" | out-file -append $logfile
          "`n" | out-file -append $logfile
          "`n" | out-file -append $logfile
                     
          #Creates the mailbox, applies the settings and then updates the log file.
          Enable-Mailbox -Identity $Username -Alias $Username -Database $Database
          Set-mailbox -Identity $Username -EmailAddressPolicyEnabled $false 
          Set-Mailbox -Identity $Username -CustomAttribute1 $newattribute1 
          Set-Mailbox -Identity $Username -CustomAttribute8 $newattribute8 
          Set-Mailbox -Identity $Username -CustomAttribute10 $newattribute10 
          Set-Mailbox -Identity $Username -HiddenFromAddressListsEnabled $False
          Set-Mailbox -Identity $Username -PrimarySmtpAddress $Email1

          #Checks to see if the email box has a Transpo or library email and applies SMTP, RFAX and X400 settings required.
              if ($Email1 -contains "transpo" -or $Email1 -contains "biblioottawalibrary")
                
                  {
                     Set-Mailbox -Identity $Username -EmailAddresses "SMTP:$Email1", "SMTP:$Email2", "X400:$x400"
                     $Temp = Get-Mailbox -Identity $Username
                     $Temp.EmailAddresses += ("$Rfax")
                     Set-Mailbox -Identity $Username -EmailAddresses $Temp.EmailAddresses
                     
                  }

                   else

                        {
                           Set-Mailbox -Identity $Username -EmailAddresses "SMTP:$Email1", "X400:$X400"
                           $Temp = Get-Mailbox -Identity $Username
                           $Temp.EmailAddresses += ("$Rfax")
                           Set-Mailbox -Identity $Username -EmailAddresses $Temp.EmailAddresses

                        }
                
                          #Checks to see if the email box is using default settings or not and applies settings required.
                          if ($defaults -eq "Yes")
                
                              {
                                 Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $True 
                              }

                               else

                                    {
                                       Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $False
                                       Set-Mailbox -identity $Username -ProhibitSendquota $SendQuota
                                       Set-Mailbox -identity $Username -IssueWarningQuota $Warning
                                    }

             
          "------------------------New mailbox created for $username with the following settings:------------------------" | out-file -append $logfile
          Get-mailbox -identity $username | FL *customattribute* | out-file -append $logfile
          Get-Mailbox -identity $UserName | FL *Quota* | out-file -append $logfile 
          Get-Mailbox -identity $username | FL *GrantSendOnBehalfTo* | out-file -append $logfile 
          Get-Mailbox -identity $username | FL *forward* | out-file -append $logfile
          Get-Mailbox -identity $username | FL *ProcessExternalMeetingMessages* | out-file -append $logfile
          Get-Mailbox -identity $Username | List PrimarySmtpAddress, EmailAddresses | out-file -append $logfile
  
          "`n" | out-file -append $logfile
          " ________________________________________________________" | out-file -append $logfile
          "`n" | out-file -append $logfile
          "`n" | out-file -append $logfile
        }    
          
          Else
          
               {
                 #Account already exists and changes settings to enable it.
                 "Account already exists, Re-enabling Account $username" | out-file -append $logfile
                 "`n" | out-file -append $logfile
                 "`n" | out-file -append $logfile
                 "------------------------Account old settings for $username------------------------" | out-file -append $logfile
                 "`n" | out-file -append $logfile
                   
                 $newattribute1 = $user.attribute1
                 $newattribute8 = $user.attribute8
                 $newattribute10 = $user.attribute10
                 $Warning = [String]$user.warnings+'MB'
                 $Sendquota = [String]$user.quota+'MB'
                 $Defaults = $user.defaults
                 
                 #Gets actual settings of mailbox and outputs them to the logfile.          
                 Get-mailbox -identity $username | FL *customattribute* | out-file -append $logfile
                 Get-mailbox -identity $username | FL *HiddenFromAddressListsEnabled* | out-file -append $logfile
                 Get-mailbox -identity $username | FL *IssueWarningQuota* | out-file -append $logfile
                 Get-mailbox -identity $username | FL *ProhibitSendquota* | out-file -append $logfile
                 Get-Mailbox -identity $UserName | FL *Quota* | out-file -append $logfile 
                 Get-Mailbox -identity $username | FL *GrantSendOnBehalfTo* | out-file -append $logfile 
                 Get-Mailbox -identity $username | FL *forward* | out-file -append $logfile  
                 
                 #Sets mailbox with new settings.
                 Set-Mailbox -Identity $username -CustomAttribute8 $newattribute8 
                 Set-Mailbox -Identity $username -CustomAttribute10 $newattribute10 
                 Set-Mailbox -Identity $username -HiddenFromAddressListsEnabled $False 
                    
                      #Checks to see if the email box is using default settings or not and applies settings required.            
                      if ($defaults -eq "Yes")
                             
                          {
                             Set-Mailbox -identity $username -ProhibitSendReceiveQuota Unlimited 
                             Set-Mailbox -identity $username -ProhibitSendReceiveQuota $False 
                             Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $True 
                          }
                                    
                             Else

                                  {
                                     Set-Mailbox -identity $username -ProhibitSendReceiveQuota Unlimited 
                                     Set-Mailbox -identity $username -ProhibitSendReceiveQuota $False
                                     Set-Mailbox -identity $Username -UseDatabaseQuotaDefaults $False
                                     Set-Mailbox -identity $Username -ProhibitSendquota $SendQuota 
                                     Set-Mailbox -identity $Username -IssueWarningQuota $Warning
                                  }
                                    
                 #Gets new settings of mailbox and outputs them to the logfile.                    
                 "------------------------New existing mailbox settings for $username------------------------" | out-file -append $logfile

                 Get-mailbox -identity $username | FL *customattribute* | out-file -append $logfile
                 Get-mailbox -identity $username | FL *HiddenFromAddressListsEnabled* | out-file -append $logfile
                 Get-Mailbox -identity $UserName | FL *Quota* | out-file -append $logfile 
                 Get-Mailbox -identity $username | FL *GrantSendOnBehalfTo* | out-file -append $logfile 
                 Get-Mailbox -identity $username | FL *forward* | out-file -append $logfile
                 Get-Mailbox -identity $username | FL *ProcessExternalMeetingMessages* | out-file -append $logfile
                 Get-Mailbox -identity $Username | List PrimarySmtpAddress, EmailAddresses | out-file -append $logfile

                 "`n" | out-file -append $logfile
                 " ________________________________________________________" | out-file -append $logfile
                 "`n" | out-file -append $logfile
                 "`n" | out-file -append $logfile
               }

}

#Informs that script is done, trims end of each line to remove extra spaces and then opens the log file to show the data.
$content = Get-Content $logfile
$content | Foreach {$_.TrimEnd()} | Set-Content $logfile
start notepad $logfile

#Makes a copy of the CSV file used to the log area in the CSVFileUsed directory
copy-item '\\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\CSV\Updates.csv' $Reportfile

Write-Host ""
Write-Host ""

<################################################################################>
<##                                                                            ##>
<##                     Calls the Exchange Calendar Script                     ##>
<##                                                                            ##>
<################################################################################>

Write-Host "Starting Exchange Calendar Script"

Invoke-Expression \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\exchangecalendar.ps1

Write-Host "completed Calendar Script"

Write-Host ""
Write-Host ""


<################################################################################>
<##                                                                            ##>
<##                        Calls the FinalLog Script                           ##>
<##                                                                            ##>
<################################################################################>

Write-Host "Starting Final Log Script"

Invoke-Expression \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\FinalLog.ps1

Write-Host "Completed Final Log Script"

Write-Host ""
Write-Host ""


<################################################################################>
<##                                                                            ##>
<##                        Calls the Solution Script                           ##>
<##                                                                            ##>
<################################################################################>

Write-Host "Starting Solution Script"

Invoke-Expression 'powershell -version 3 \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts\Solution.ps1'

Write-Host "Completed Solution Script"

#Removes the master CSV file used to run the script.
Remove-Item \\dc1fap003\Ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\CSV\Updates.csv