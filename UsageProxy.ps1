$UsageProxy = Get-SPServiceApplicationProxy | where {$_.TypeName -like "Usage*"}
$UsageProxy.Provision()