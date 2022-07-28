Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
#Upgrade a single database
$DatabaseName = "WSS_Content_Name"
#Get the Database ID
$DatabaseID = (Get-SPContentDatabase -identity $DatabaseName).ID
#Update Content Database
Upgrade-SPContentDatabase -id $DatabaseID -Confirm:$false
#
#########################################################################
#
#Upgrade all DBs for a site
$WebAppURL= "https://url.domain.com"
 
#Get all content databases of the particular web application
$ContentDBColl = (Get-SPWebApplication -Identity $WebAppURL).ContentDatabases
 
foreach ($contentDB in $ContentDBColl)
{
   #Updade each content database
   Upgrade-SPContentDatabase -id $contentDB.Id -Confirm:$false
}
#
#########################################################################
#
#Upgrade all DBs that need upgrading
Get-SPContentDatabase | ?{$_.NeedsUpgrade -eq $true} | Upgrade-SPContentDatabase