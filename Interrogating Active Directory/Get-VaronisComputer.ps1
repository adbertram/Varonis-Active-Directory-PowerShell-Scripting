function Get-VaronisComputer {
    param(
        [string[]]$Properties = '*'
    )
    Get-ADComputer -Filter * -Properties $Properties
}