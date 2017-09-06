function Get-VaronisComputer {
    param()
    Get-ADComputer -Filter *
}