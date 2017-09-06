$demoPath = 'C:\Dropbox\Business Projects\Courses\Varonis\Learning PowerShell and How to Keep Active Directory Secure and Healthy\Modules\3. Working with Active Directory\Demos'

## Start with a CSV file full of employee names and information
Import-Csv "$demoPath\Users.csv"

## Let's build these users via the GUI
<# Requirements:
 - Must be in a different OU depending on the department
 - Must be added to an All Users group
 - common password
 - ensure password is changed at logon
 - Username is first initial/last name. 
    - If that's taken it's first initial/middle initial/last name. 
#>
dsa.msc

## Let's build these users with PowerShell

ise "$demoPath\CreateAcmeUser.ps1"



