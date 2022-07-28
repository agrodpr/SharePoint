Add-PSSnapin Microsoft.SharePoint.Powershell;
#
#Variables a setear
$InternalSite="intranet.domain.local"
$InternalSiteUrl="http://$InternalSite"
$InternalSitePort="80"
$ap = New-SPAuthenticationProvider
$PoolAdmin="DOMAIN\SPPool"
$SqlServer="SQLALIAS"
$SqlDB="WSS_Content_Intranet_delete"
#
#Crear el site Interno
New-SPWebApplication -Name $InternalSite -HostHeader $InternalSite -URL $InternalSiteUrl -Port $InternalSitePort -ApplicationPool $InternalSite  -ApplicationPoolAccount (Get-SPManagedAccount $PoolAdmin) -AuthenticationProvider $ap -DatabaseServer $SqlServer -DatabaseName $SqlDB
#
#Crear alternate site bindings
New-SPAlternateURL -WebApplication "$InternalSite" -URL "http://intranet" -Zone Intranet
New-SPAlternateURL -WebApplication "$InternalSite" -URL "https://intranet.domain.com" -Zone Extranet

#
#Crear IIS bindings
New-WebBinding -Name $InternalSite -Protocol http -IP * -Port 80 -HostHeader intranet
New-WebBinding -Name $InternalSite -sslFlags 1 -Protocol https -IP * -Port 443 -HostHeader intranet.mcs.com.pr
#
#Montar base de datos de contenido
#
Mount-SPContentDatabase "WSS_Content_Name1" -DatabaseServer $SqlServer -WebApplication $InternalSiteUrl
Mount-SPContentDatabase "WSS_Content_Name2" -DatabaseServer $SqlServer -WebApplication $InternalSiteUrl
Mount-SPContentDatabase "WSS_Content_Name3" -DatabaseServer $SqlServer -WebApplication $InternalSiteUrl
#
#Desmontar base de datos de contenido inicial
Dismount-SPContentDatabase $SqlDB