Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue
#Set the search service application name
$SSA = "Search Service Application - Name"
#Get the search service application status
Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $SSA | select Name, CrawlStatus
#Get the search service application
$ContentSourceName="Local SharePoint sites" #default "Local SharePoint sites"
$SSA.ActiveTopology.GetComponents() | ? {$_.Name -like "IndexComponent*"}
#Get the content source
$ContentSource = Get-SPEnterpriseSearchCrawlContentSource -Identity $ContentSourceName -SearchApplication $SSA
##Change the name in case you are using a different name for the search service application

#Check if Crawler is not already runnin
if($ContentSource.CrawlState -ne "Idle")
    {
        Write-Host "Stopping Crawl..."          
        $ContentSource.StopCrawl()
        #Wait till its stopped
        while($ContentSource.CrawlState -ne "Idle")
        {
            Write-Host "Waiting to crawl to be stopped..." -f DarkYellow
            sleep 5
        }
        write-host "Crawl Stopped Successfully!" -f DarkGreen
    }
  else
    {   
        Write-Host "Search Crawl is not running!" -f Red
    }