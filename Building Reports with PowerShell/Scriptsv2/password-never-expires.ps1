function Get-PasswordNeverExpires {
    param(
        [object[]]$Users
    )

    $Users | where { -not $_.PasswordNeverExpires }
}