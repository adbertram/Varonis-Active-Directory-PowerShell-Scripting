function Find-TextFile {
    param(
        [Parameter()]
        $Name
    )

    Get-ChildItem -Path 'C:\Demos' -Filter "*$Name*.txt"
}

function Set-TextFile {
    param(
        [Parameter()]
        $Path,
        [Parameter()]
        $Value
    )

    Set-Content -Path $Path -Value $Value
}

$textFile = Find-TextFile -Name 'whatever'
Set-TextFile -Path $textFile.FullName -Value 'I changed this file!'
Get-Content -Path $textFile.FullName