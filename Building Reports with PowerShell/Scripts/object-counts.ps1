function Get-ObjectCounts {

    [pscustomobject]@{
        ExpiredPasswords = (Get-ExpiredPasswords).Count
        LockedOutAccounts = (Get-LockedOutAccounts).Count
        PasswordNotSet = (Get-PasswordNotSet).Count
        PasswordNeverExpires = (Get-PasswordNeverExpires).Count
        CachedPasswordsOnRODCs = (Invoke-RODCPasswordDiscovery).Count
    }
}