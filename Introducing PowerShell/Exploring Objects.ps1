## Everything is an object in PowerShell

$string = Write-Output 'Hello, world!'

## Looks like a simple string
$string

## Dive deeper with Get-Member

$string | Get-Member

## Reference properties on this string object with dot notation

## Find the length of the string
$string.Length

## Do things to the string with methods --methods are called with a dot surrounded by parens
$string.ToUpper() ## no argument
$string.Trim(' ,world!') ## with an argument

## Different commands produce different objects with different properties and methods

$service = Get-Service -Name   ## tab-complete on some parameter values too!

$service | gm ## using an alias here

Get-Alias

## You can create your own objects too --lots of ways to do this but this is the easiest

## Define a hashtable type. Hashtable = key/value pairs
$hashtable = @{ Color = 'Red'; Transmission = 'Automatic'; Convertible = $false }

$hashtable | Get-Member

## Convert thes key/value pairs into an object with properties
$car = [pscustomobject]$hashtable

$car | Get-Member