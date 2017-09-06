## Where-Object
Get-ADComputer -Filter * | Where-Object { $_.Name -like '*SQL*' }

## .Where() PS v4+
(Get-ADComputer -Filter *).where({ $_.Name -like '*SQL*' })

## Provider-specific filter "Filter left"
Get-ADComputer -Filter "Name -like '*SQL*'"
