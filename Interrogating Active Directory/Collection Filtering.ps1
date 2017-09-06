## Lots of ways to filter

$array = 0..10

## as long as the where filter returns $true or some output other than $false
$array | Where-Object { $_ -gt 2 }
$array.where({$_ -gt 2})
$array.where({ $_ -in @(3,4,5,6,7,8,9,10) })
$array.where({ 'hello' })
