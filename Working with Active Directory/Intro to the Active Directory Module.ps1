## Once RSAT is installed, confirm the ActiveDirectory module is enabled
appwiz.cpl

## Ensure that the module is available
Get-Module -Name ActiveDirectory -ListAvailable

## Check out all commands inside of the module
Get-Command -Module ActiveDirectory

#region Run a quick test to ensure you can read various objects

## Read a user account
Get-AdUser -Filter "samaccountname -eq 'Administrator'"

## Read a computer account
Get-ADComputer -Filter "Name -eq 'DC'"

## Read a group
Get-ADGroup -Filter "Name -eq 'Domain Admins'"

#endregion

## How the AD module displays attributes
Get-AdUser -Filter "samaccountname -eq 'Administrator'"

## Notice only a few user attributes even though Select-Object * should show them all
Get-AdUser -Filter "samaccountname -eq 'Administrator'" | Select-Object *

## Must use the -Property parameter. This is unique to the AD module
Get-AdUser -Filter "samaccountname -eq 'Administrator'" -Property *

#region AD attributes do not match up 1:1 with AD module output

## Old-school way of pulling information from AD with ADSI
$searcher = [adsisearcher]"(&(objectClass=user)(objectCategory=person)(samAccountName=administrator))"
$realAttribs = $searcher.FindAll() | Select-Object -ExpandProperty Properties
$realAttribs

## The AD module makes LDAP attributes "friendlier"
$adModuleUser = Get-AdUser -Filter "samaccountname -eq 'Administrator'" -Property *
$adModuleUser

## LastLogon is a great example
$realAttribs.lastLogon
$adModuleUser.LastLogonDate

#endregion