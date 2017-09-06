function Get-ObjectCounts {
    param(
        [object[]]$Users,
        [object[]]$DomainController
    )
    [pscustomobject]@{
        ExpiredPasswords = (Get-ExpiredPasswords -Users $Users).Count
        LockedOutAccounts = (Get-LockedOutAccounts -Users $Users).Count
        PasswordNotSet = (Get-PasswordNotSet -Users $Users).Count
        PasswordNeverExpires = (Get-PasswordNeverExpires -Users $Users).Count
        CachedPasswordsOnRODCs = (Invoke-RODCPasswordDiscovery -DomainController $DomainController).Count
    }
}