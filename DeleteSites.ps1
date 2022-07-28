Add-PSSnapin Microsoft.SharePoint.Powershell;
#
#Delete site collection through PowerShell
#
#Enter SiteURL
$SiteURL = "https://url.domain.com/sites/name"
Remove-SPSite -Identity $SiteURL
#
#Force delete SharePoint site collection with PowerShell
#
#Get the site collection to delete
$Site = Get-SPSite https://site-collection-url
#
#Get the content database of the site collection
$SiteContentDB = $site.ContentDatabase 
#
#Force delete site collection
$SiteContentDB.ForceDeleteSite($Site.Id, $false, $false)
#
#Bulk delete site collections with PowerShell in SharePoint
#
Get-SPSite "https://sharepoint.crescent.com/sites*" -Limit ALL | Remove-SPSite -Confirm:$false
#
#PowerShell to delete all site collections under a web application:
#
#Web Application URL
$WebAppURL="https://SharePoint.crescent.com"
# 
#Get Each site collection and delete
Get-SPWebApplication $WebAppURL | Get-SPSite -Limit ALL | Remove-SPSite -Confirm:$false