Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue
$SSA = Get-SPEnterpriseSearchServiceApplication -Identity "Search Service Application - Name"
$ssa.refreshcomponents()
$ssa.Status
$ssa.Status = "Disabled"
$ssa.Update()
$ssa.Provision()