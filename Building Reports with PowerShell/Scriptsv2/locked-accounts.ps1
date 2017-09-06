function Get-LockedOutAccounts {
    param(
        [object[]]$Users
    )
    $Users | where { -not $_.LockedOut }
}