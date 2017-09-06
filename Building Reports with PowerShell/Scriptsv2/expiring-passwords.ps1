function Get-ExpiringPasswords {
    param(
        [object[]]$Users
    )
    ($Users | Where {
        -not $_.PasswordNeverExpires -and 
        -not $_.PasswordExpired -and
        (((Get-Date) - ([datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed'))).Days -lt 30)
    })
}