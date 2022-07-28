Add-PSSnapin Microsoft.SharePoint.Powershell;

# Install Solution Files

$FilePath="C:\wsp\"

$Wsps = 
"Name1.wsp"
"Name2.wsp",
"Name3.wsp",
"Name4.wsp",
"Name5.wsp"

foreach ($Wsp in $Wsps)
{
  Write-Host "Installing " + $Wsp
  Add-SPSolution -LiteralPath ($FilePath + $Wsp)
  Install-SPSolution -Identity $Wsp -GACDeployment
  Write-Host $Wsp + "Done. :)"
}