function Get-VaronisUser {
    param(
        [string[]]$Properties = '*'
    )
    Get-ADUser -Filter * -Properties $Properties
}
