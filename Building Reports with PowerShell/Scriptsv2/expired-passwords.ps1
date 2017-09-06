function Get-ExpiredPasswords {
    param(
        [object[]]$Users
    )
    $Users | where { -not $_.PasswordExpired }
}