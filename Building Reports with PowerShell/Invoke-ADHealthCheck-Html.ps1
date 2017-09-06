$scriptsPath = 'C:\Dropbox\Business Projects\Courses\Varonis\Learning PowerShell and How to Keep Active Directory Secure and Healthy\Modules\6. Building Reports with PowerShell\Demos\Scripts'
$htmlFilePath = 'C:\ADHealthCheck.htm'

## Dot source all scripts
(Get-ChildItem -Path $scriptsPath).foreach({ . $_.FullName })

$output = @{}

$properties = @(
    '*'
    'msDS-UserPasswordExpiryTimeComputed'
)
$adUsers = Get-AdUser -Filter "Enabled -eq 'True'" -Properties $properties

## How would I like this report to look like anyway?

<#
Active Directory Health Check Report
--------------------------------

ExpiredPasswords        | XXX
ExpiringPasswords       | XXX
LockedOutAccounts       | XXX
PasswordNeverExpires    | XXX
CachedPasswordsOnRODCs  | XXX

DCDiagTestResults
------------------
TestName | Succeeded/Failed
TestName | Succeeded/Failed
TestName | Succeeded/Failed
.....

Replication Status
-------------------
DomainController | LastReplicationAttempt | ReplicationStatus
DC1                1/1/17 12:34AM           Success
DC2                1/1/17 12:34AM           Success
DC3                1/1/17 12:34AM           Failed
...

Database Status
-------------------
DomainController | DBSize | Whitespace Logging Enabled
DC1                10MB     $true
DC2                12MB     $false
DC3                17MB     $true
...

--------------------------------
Ran: 01/01/17 12:34AM

#>
#region First attempt
## First break out each section
$countDisplay = @{
    ExpiredPasswords = ($adUsers | Where {$_.PasswordExpired}).Count
    LockedOutAccounts = ($adUsers | where {$_.LockedOut}).Count
    PasswordNotSet = ($adUsers | where {-not $_.PasswordLastSet}).Count
    PasswordNeverExpires = ($adUsers | where { $_.PasswordNeverExpires}).Count
    CachedPasswordsOnRODCs = (Invoke-RODCPasswordDiscovery)
}

#region User passwords to expire soon
$countDisplay.ExpiringPasswords = ($adUsers | Where {
    -not $_.PasswordNeverExpires -and 
    -not $_.PasswordExpired -and
    (((Get-Date) - ([datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed'))).Days -lt 30)
    }).Count
#endregion

## Create the entire page first
## Use -List here
[pscustomobject]$countDisplay | ConvertTo-Html -Title 'Active Directory Health Check Report' -As List | Out-File $htmlFilePath

## We use the -Fragment option here because we're appending. Just create the HTML table.
$dcDiag = Invoke-DCDiag 
$dcDiag | ConvertTo-Html -Fragment -PostContent '<br />' | Out-File $htmlFilePath -Append

$replMonitor = Invoke-ReplicationMonitor
$replMonitor | ConvertTo-Html -Fragment -PostContent '<br />' | Out-File $htmlFilePath -Append
[pscustomobject]$countDisplay | ConvertTo-Html -Title 'Active Directory Health Check Report' -PostContent '<br />' -As List | Out-File $htmlFilePath

$dbInfo = Invoke-ADDatabaseInfo
$dbInfo | ConvertTo-Html -Fragment | Out-File $htmlFilePath -Append
#endregion

#region Need table captions

## Set table captions for each section
[pscustomobject]$countDisplay | ConvertTo-Html -PreContent '--------------' -Title 'Active Directory Health Check Report' -PostContent '<br />' -As List | Out-File $htmlFilePath
$dcDiag | ConvertTo-Html -Fragment -PreContent 'DCDiagTestResults<br>--------------' -PostContent '<br />' | Out-File $htmlFilePath -Append
$replMonitor | ConvertTo-Html -Fragment -PreContent 'Replication Status<br>--------------'  -PostContent '<br />' | Out-File $htmlFilePath -Append
$dbInfo | ConvertTo-Html -PreContent 'Database Status<br>--------------'  -Fragment | Out-File $htmlFilePath -Append

#endregion

#region Tweaking the AD health check tool

## Next, we'll need to get each DC showing up correctly on the replication status and database status sections
## This will require a modification of the original tool.

## Almost there! Now just remove a couple properties from the HTML table
[pscustomobject]$countDisplay | ConvertTo-Html -PreContent '--------------' -Title 'Active Directory Health Check Report' -PostContent '<br />' -As List | Out-File $htmlFilePath
$dcDiag | ConvertTo-Html -Fragment -PreContent 'DCDiagTestResults<br>--------------' -PostContent '<br />' | Out-File $htmlFilePath -Append
$replMonitor | ConvertTo-Html -Fragment -PreContent 'Replication Status<br>--------------'  -PostContent '<br />' | Out-File $htmlFilePath -Append
$dbInfo | ConvertTo-Html -PreContent 'Database Status<br>--------------' -Property DomainController,DBFilePath,DBSize,WhiteSpaceLoggingEnabled -PostContent "Ran: $((Get-Date).ToString())"  -Fragment | Out-File $htmlFilePath -Append

#endregion
