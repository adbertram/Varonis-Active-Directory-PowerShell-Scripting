## Open up the console
powershell

## All legacy commands are still avaiable
ping DC
ipconfig
dir C:\

## Now you have PowerShell commands available too
Get-Command ## Verb-Noun syntax

## Easy tab completion of tab parameters. This is Intellisense and works in script editors as well.
Get-Command

Get-Command -N

Get-Command -Noun Write
Get-Command -Verb Set
Get-Content

## Compare cmd vs. PowerShell --PowerShell provides more structure

## Example: CMD: list every subfolder in C:\Example that has a name starting with Foo
cd C:\Example
cmd
FOR /D /r %G in ("Foo*") DO @Echo %G
exit

## PowerShell --more verbose, easier to understand
Get-ChildItem -Path 'C:\Example' -Filter 'Foo*' -Directory -Recurse

## Ping vs. Test-Connection

ping DC
Test-Connection DC

## type vs. Get-Content

Add-Content -Path C:\Example.txt -Value 'localhost','DC','LABSQL'
type 'C:\Example.txt'
Get-Content 'C:\Example.txt' ## not much difference on the surface

## Now do something to each line of that text file -- perhaps this is a list of computers
for /F "tokens=*" %A in (C:\Example.txt) do ping %A

Get-Content 'C:\Example.txt' | foreach { ping $PSItem }