## See what we're up against
ipconfig

## Define what we'd like to parse out

## Create an expected object that our script will eventually return when done
@{
    Adapter = 'Ethernet'
    IPV4Address = '192.168.0.122'
    SubnetMask = '255.255.255.0'
}

## Introducing Select-String
$testString = 'Test: Whatever - Failed
Test: Something - Failed
Test: Foo - Succeeded'

## One big string
$testString

## Let's break this out into an array to search by line
$testArray = $testString -split "`n"
$testArray[0]
$testArray[1]

## We can now search on each element inside
$testArray | Select-String -Pattern 'Test: Foo'

## Select-String can also use regex and create capturing groups to find matches inside of strings without conversion
$allMatches = $testString | Select-String -Pattern 'Test: Foo - (.*)' -AllMatches
$allMatches
$allMatches | ForEach-Object { $_.Matches }
$allMatches | ForEach-Object { $_.Matches.Groups }
$allMatches | ForEach-Object { $_.Matches.Groups[1] }
$allMatches | ForEach-Object { $_.Matches.Groups[1].Value }

## Applying Select-String to ipconfig's output
$ipconfigOutput = ipconfig
$ipconfigOutput

## Parse out the adapter name
$ipconfigOutput | Select-String -Pattern 'Ethernet adapter (.*):' | foreach { $_.Matches.Groups[1].Value }

## Parse the IPV4 Address
$ipconfigOutput | Select-String -Pattern 'IPV4 Address[\.|\s]+: (.*)' | foreach { $_.Matches.Groups[1].Value }

## Parse the Subnet
$ipconfigOutput | Select-String -Pattern 'Subnet Mask[\.|\s]+: (.*)' | foreach { $_.Matches.Groups[1].Value }

## Each attribute looks very similar to retrieve. We can eliminate this duplication with a loop
$properties = @{
    Adapter = 'Ethernet adapter (.*):'
    IPV4Address = 'IPV4 Address[\.|\s]+: (.*)'
    SubnetMask = 'Subnet Mask[\.|\s]+: (.*)'
}

$futureObject = @{}
$properties.GetEnumerator().foreach({
    $futureObject[$_.Key] = $ipconfigOutput | Select-String -Pattern $_.Value | foreach { $_.Matches.Groups[1].Value }
})

[pscustomobject]$futureObject
