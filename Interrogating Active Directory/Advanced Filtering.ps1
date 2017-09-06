## Provider-specific filtering

## File system has the C: drive --no output but no errors either.
## The filter knows this is a file system and to filter on files
Get-ChildItem -Path 'C:\Windows' -Filter '*.doc'

## Returns everything because it doesn't know what *.doc should filter on
Get-ChildItem -Path 'AD:\DC=mylab,DC=local' -Filter '*.doc'

Get-Help about_ActiveDirectory_Filter

## Limiting search for AD cmdlets
(Get-AdUser -Filter *).Count
(Get-AdUser -Filter * -SearchBase 'OU=AutomationLists,DC=mylab,DC=local').Count
(Get-AdUser -Filter * -SearchScope Subtree).Count
