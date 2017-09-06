$demoPath = 'C:\Dropbox\Business Projects\Courses\Varonis\Learning PowerShell and How to Keep Active Directory Secure and Healthy\Modules\3. Working with Active Directory\Demos'
$employees = Import-Csv "$demoPath\Users.csv"

$commonUserPassword = (Get-Credential -Message 'What is the initial password for each account?').GetNetworkCredential().Password

## Do some stuff for each employee in the CSV file
foreach ($employee in $employees)
{
    #region Figure out the username to assign
    $firstInitial = $employee.FirstName.SubString(0,1)
	$username = "$firstInitial$($employee.LastName)"
    Write-Verbose -Message "Checking username [$($username)]..."
    if (Get-AdUser -Filter "samAccountName -eq '$username'") {
        Write-Warning "Username [$($username)] is taken."
        ## Check the second username
        $userName = '{0}{1}{2}' -f $firstInitial,$employee.MiddleInitial,$employee.LastName
        Write-Verbose -Message "Checking username [$($username)]..."
        if (Get-AdUser -Filter "samAccountName -eq '$username'") {
            throw "The username [$($username)] is already taken. Unable to create user."
        }
    }
    #endregion

    #region Create the user ensuring it's in the right OU
    $NewUserParams = @{
		'Title' = $employee.Title
        'UserPrincipalName' = $Username
		'Name' = $Username
        'Path' = "OU=$($employee.Department),DC=mylab,DC=local"
		'GivenName' = $employee.FirstName
		'Surname' = $employee.LastName
		'SamAccountName' = $Username
        'DisplayName' = "$($employee.FirstName) $($employee.LastName)"
        'Department' = $employee.Department
		'AccountPassword' = (ConvertTo-SecureString $commonUserPassword -AsPlainText -Force)
		'Enabled' = $true
		'Initials' = $employee.MiddleInitial
		'ChangePasswordAtLogon' = $true
	}
    Write-Verbose -Message "Creating user [$($username)]..."
    New-AdUser @NewUserParams
    Write-Verbose -Message 'DONE'
    #endregion

    ## Add the user to the All users group
    Write-Verbose -Message "Adding user to All Users group..."
    Add-ADGroupMember -Identity 'All Users' -Members $Username
    Write-Verbose -Message 'DONE'
}