Add-PSSnapin Microsoft.SharePoint.Powershell;

#Variables a setear
$PublicSite="public.domain.com"
$PublicSiteUrl="https://$PublicSite"
$PublicSitePort="443"

$InternalSite="internal.domain.com"
$InternalSiteUrl="https://$InternalSite"
$InternalSitePort="443"

$ap = New-SPAuthenticationProvider
$PoolAdmin="DOMAIN\SPPool"
$SqlServer="SQLServer"
$SqlDB="WSS_Content_Name"

#Crear el site de manejo
New-SPWebApplication -Name $InternalSite -HostHeader $InternalSite  -URL $InternalSiteUrl -Port $InternalSitePort -ApplicationPool $InternalSite  -ApplicationPoolAccount (Get-SPManagedAccount $PoolAdmin) -AuthenticationProvider $ap -DatabaseServer $SqlServer -DatabaseName $SqlDB -SecureSocketsLayer

#Crear el site publico
Get-SPWebApplication ($InternalSiteUrl+":"+$InternalSitePort) | New-SPWebApplicationExtension -Name $PublicSite -Zone "Internet" -URL $PublicSiteUrl -HostHeader $PublicSite -Port $PublicSitePort -AllowAnonymousAccess -SecureSocketsLayer

#Crear bindings
Get-WebBinding -Port 443 -Name $InternalSite | Remove-WebBinding
New-WebBinding -Name $InternalSite -sslFlags 1 -Protocol https -IP * -Port 443 -HostHeader $InternalSite
New-WebBinding -Name $InternalSite -Protocol http -IP * -Port 80 -HostHeader $InternalSite
Get-WebBinding -Port 443 -Name $PublicSite | Remove-WebBinding
New-WebBinding -Name $PublicSite -sslFlags 1 -Protocol https -IP * -Port 443 -HostHeader $PublicSite
New-WebBinding -Name $PublicSite -sslFlags 1 -Protocol https -IP * -Port 443 -HostHeader ("www."+$PublicSite)
New-WebBinding -Name $PublicSite -Protocol http -IP * -Port 80 -HostHeader $PublicSite
New-WebBinding -Name $PublicSite -Protocol http -IP * -Port 80 -HostHeader ("www."+$PublicSite)
Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/windowsAuthentication' -Name 'enabled' -Value 'true' -PSPath 'IIS:\' -Location "$PublicSite/$InternalSite"

#Configurar el site de zona de Internet como anonimo
$web = Get-SPWeb ($PublicSiteUrl+":"+$PublicSitePort)
$web.AnonymousState = [Microsoft.SharePoint.SPWeb+WebAnonymousState]::Enabled
$web.AnonymousPermMask64 = "Open, OpenItems, UseClientIntegration, ViewPages, ViewListItems, UseRemoteAPIs"
$web.AllowAnonymousAccess
$web.Update()

$webapp = Get-SPWebApplication ($PublicSiteUrl+":"+$PublicSitePort)
$webApp.IisSettings['Internet'].AllowAnonymous=$true;
$webapp.ClientCallableSettings.AnonymousRestrictedTypes.Remove([microsoft.sharepoint.splist], "GetItems")
$webapp.Update()