$scriptsPath = 'C:\Dropbox\Business Projects\Courses\Varonis\Learning PowerShell and How to Keep Active Directory Secure and Healthy\Modules\5. Hands-Free Active Directory Health\Demos'

## Make our functions built previously available
$scripts = @(
    'Get-VaronisComputer.ps1'
    'Get-VaronisUser.ps1'
    'Get-VaronisGroup.ps1'
    'dcdiag.ps1'
    'replication-monitoring.ps1'
    'rodc-cached-passwords.ps1'
    'ad-database.ps1'
)

## Dot source all scripts
$scripts.foreach({ . "$scriptsPath\$_" })

$output = @{}

$properties = @(
    '*'
    'msDS-UserPasswordExpiryTimeComputed'
)
$adUsers = Get-AdUser -Filter "Enabled -eq 'True'" -Properties $properties

#region User passwords to expire soon
$output.ExpiringPasswords = ($adUsers | Where {
    -not $_.PasswordNeverExpires -and 
    -not $_.PasswordExpired -and
    (((Get-Date) - ([datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed'))).Days -lt 30)
    }).Count
#endregion

$output.ExpiredPasswords = ($adUsers | Where {$_.PasswordExpired}).Count
$output.LockedOutAccounts = ($adUsers | where {$_.LockedOut}).Count
$output.PasswordNotSet = ($adUsers | where {-not $_.PasswordLastSet}).Count
$output.PasswordNeverExpires = ($adUsers | where { $_.PasswordNeverExpires}).Count
$output.DCDiagResult = (Invoke-DCDiag)
$output.ReplicationStatus = (Invoke-ReplicationMonitor)
$output.CachedPasswordsOnRODCs = (Invoke-RODCPasswordDiscovery)
$output.ADDatabaseInfo = (Invoke-ADDatabaseInfo)

[pscustomobject]$output