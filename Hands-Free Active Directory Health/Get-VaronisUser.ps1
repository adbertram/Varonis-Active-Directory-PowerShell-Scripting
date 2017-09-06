function Get-VaronisUser {
    $demoPath = 'C:\Dropbox\Business Projects\Courses\Varonis\Learning PowerShell and How to Keep Active Directory Secure and Healthy\Modules\5. Hands-Free Active Directory Health\Demos'
    
    ## Let's find usernames for a list of FirstName/LastName employees in a CSV
    $csvusers = Import-Csv -Path "$demoPath\Users.csv"

    $allAdUsers = Get-AdUser -Filter *

    foreach ($csvUser in $csvusers) {
        $allAdUsers | Where-Object {$_.givenName -eq $csvUser.FirstName -and $_.surName -eq $csvUser.LastName }
    }
}