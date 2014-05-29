﻿#################################################################################################
#CreateDisabledShare.ps1 with elevated privileges
#
#PREREQUISITE: An encrypted password token must be created for each user/machine that will
#              run this script
#
#This script runs an elevated NT Admin script with admin credentials necessary to perform NT
#Admin functions on the NetApp
#
#City contact: Suzanne Groulx
#TI contact: Brian McDonald
#Date last modified: February 27, 2014
#################################################################################################
$da = "a\svc-tiscripts" 
$P = Get-Content C:\temp\donotdelete.txt | convertto-securestring 
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $da, $P 
$drive = "NTAdmin"
$server = "CMFP033" 
New-PSDrive -Name $drive -PSProvider FileSystem -Root "\\$server\d$\Powershell\NTAdminScripts" -Credential $cred
set-Location ntadmin:
Invoke-Expression ./Createdisabledshare.ps1
cd "\\dc1fap003\ito\isd\CSB\ITSSWiki\SD\NTA\Scripts\EDS\Create\Scripts"
Remove-PSDrive -Name NTAdmin