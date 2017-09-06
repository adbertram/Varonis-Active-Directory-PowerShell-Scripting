## Get a list of all of the modules available
Get-Module

## But..this doesn't include ALL modules. Just the ones that are loaded into memory. Modules are loaded on-demand
Get-Module -ListAvailable

## Manually import a module

## Does not show up
Get-Module -Name ActiveDirectory

## Manually import it
Import-Module -Name ActiveDirectory

## It's avaiable
Get-Module -name ActiveDirectory

## Check out the commands inside of the module
Get-Command -Module ActiveDirectory

## Unload the module
Get-Module -Name ActiveDirectory | Remove-Module
Get-Module -name ActiveDirectory

## Run a command inside of the module.
Get-AdComputer
Get-Module -name ActiveDirectory

## Modules are PSM1 files or DLLs stored in specific folders
$env:PSMODULEPATH

