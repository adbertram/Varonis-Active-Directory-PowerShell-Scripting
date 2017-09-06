function Get-PasswordNotSet {

    Get-AdUser -Filter * | where { -not $_.PasswordLastSet }
}