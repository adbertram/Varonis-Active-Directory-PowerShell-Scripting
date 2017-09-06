function Get-LockedOutAccounts {

    Get-AdUser -Filter * | where { -not $_.LockedOut }
}