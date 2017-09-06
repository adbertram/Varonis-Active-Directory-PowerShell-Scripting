function Get-PasswordNeverExpires {

    Get-AdUser -Filter * | where { -not $_.PasswordNeverExpires }
}