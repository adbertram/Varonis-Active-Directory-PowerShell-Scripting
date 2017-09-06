$scriptsPath = 'C:\Dropbox\Business Projects\Courses\Varonis\Learning PowerShell and How to Keep Active Directory Secure and Healthy\Modules\4. Interrogating Active Directory\Demos'

## Convert previous scripts to functions

## Make our functions built previously available by dot sourcing
$scripts = @(
    'Get-VaronisComputer.ps1'
    'Get-VaronisUser.ps1'
    'Get-VaronisGroup.ps1'
)

## Dot source all scripts
$scripts.foreach({ . "$scriptsPath\$_" })

$output = @{}

$adUsers = Get-VaronisUser -Properties '*','msDS-UserPasswordExpiryTimeComputed'
$adComputers = Get-VaronisComputer
$adGroups = Get-VaronisGroup

#region User passwords to expire soon
$output.ExpiringPasswords = ($adUsers | Where {
    -not $_.PasswordNeverExpires -and 
    -not $_.PasswordExpired -and
    (((Get-Date) - ([datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed'))).Days -lt 30)
    }).Count
#endregion

## Not using Search-AdAccount here because that queries AD every time. Since we've already collected
## all objects in variables, it will be more efficient to query the already-collected objects in memory.

$output.TotalComputers = $adComputers.Count
$output.TotalUsers = $adUsers.Count
$output.TotalGroups = $adGroups.Count
$output.UsersInDomainAdmins = ($adGroups.where({ $_.GroupName -eq 'Domain Admins' })).Members.Count
$output.ExpiredPasswords = ($adUsers | Where {$_.PasswordExpired}).Count
$output.LockedOutAccounts = ($adUsers | where {$_.LockedOut}).Count
$output.PasswordNotSet = ($adUsers | where {-not $_.PasswordLastSet}).Count
$output.PasswordNeverExpires = ($adUsers | where { $_.PasswordNeverExpires}).Count


[pscustomobject]$output