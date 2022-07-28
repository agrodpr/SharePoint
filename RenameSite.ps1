Add-PSSnapin Microsoft.SharePoint.Powershell;
$OldName = "OldName"
$NewName = "NewName"
    $webname = Get-SPWebApplication | Where {$_.Name -match $OldName}  
    $webname.Name = $NewName  
    $webname.Update()