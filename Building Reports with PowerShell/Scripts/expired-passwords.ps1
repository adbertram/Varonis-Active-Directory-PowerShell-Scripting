function Get-ExpiredPasswords {

    Get-AdUser -Filter * | where { -not $_.PasswordExpired }
}