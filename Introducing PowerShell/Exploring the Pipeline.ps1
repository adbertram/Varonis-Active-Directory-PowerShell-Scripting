## Commands can send output to the pipeline and other commands can accept it

## Two ways to specify input for commands
## the "old-fashioned way"

Restart-Service -Name AudioSrv

## The object way

$service = Get-Service -Name AudioSrv
Restart-Service -InputObject $service

## The pipeline way
Get-Service -Name AudioSrv | Restart-Service

## it doesn't work all the time because there are two kinds of ways that commands "bind" input

## Doesn't work
Get-Content C:\Example.txt
Test-Connection -ComputerName DC
Get-Content C:\Example.txt | Test-Connection

## Investigate with Get-Help
help Test-Connection -Parameter ComputerName

## Test-Connection accepts by PROPERTY NAME
## You must perform a foreach loop and read each string to create your own object with a ComputerName property
## Test-Connection than can bind the value of ComputerName to the input
Get-Content -Path C:\Example.txt | ForEach-Object { [pscustomobject]@{ComputerName = $PSItem} } | Test-Connection

