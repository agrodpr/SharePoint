  #Add SharePoint Snapin
    Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

    #Set file location
    $date = Get-Date -Format "MM-dd-yyyy-HH_mm"
    $path = "C:\Log_$date.log";

    #Increase logging to verbose
    Write-Host "Increasing ULS logging for Foundation to verbose...";

    Get-SPLogLevel  |Set-SPLogLevel -TraceSeverity VerboseEx

    #Prompting to start and setting the start time
    Read-Host "Hit enter to start, then reproduce the issue"
    $starttime = (Get-Date).AddMinutes(-1)
    Write-Host "The start time for the log file is $starttime";

    #Prompting to stop and setting the end time
    Read-Host "Hit enter to end"
    $endtime = Get-Date
    Write-Host "The ending time for the log file is $endtime";

    #Setting the log level back to normal
    Write-Host "Resetting the log level back to normal."
    Clear-SPLogLevel;

    #Merging the logs to the specified path using the start and end times
    Merge-SPLogFile -Path $path -Overwrite -StartTime $starttime -EndTime $endtime;
    Write-Host "Logs have been collected.";