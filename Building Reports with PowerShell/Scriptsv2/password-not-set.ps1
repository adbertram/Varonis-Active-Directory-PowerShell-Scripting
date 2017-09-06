function Get-PasswordNotSet {
    param(
        [object[]]$Users
    )
    $Users | where { -not $_.PasswordLastSet }
}