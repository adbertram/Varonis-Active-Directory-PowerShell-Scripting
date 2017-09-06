Get-PSProvider

Get-PSProvider -PSProvider FileSystem

Get-PSDrive

Get-ChildItem -Path C:\

Import-Module -Name ActiveDirectory

Get-PSProvider ActiveDirectory

Get-ChildItem -Path AD:\
Get-ChildItem -Path 'AD:\DC=mylab,DC=local'

Get-ChildItem -Path 'C:\' -Filter '*bertram'
Get-ChildItem -Path 'AD:\DC=mylab,DC=local' -Recurse -Filter '*bertram'

Get-ChildItem -Path 'AD:\DC=mylab,DC=local'