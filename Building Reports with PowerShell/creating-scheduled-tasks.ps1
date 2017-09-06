## Create the action to execute powershell.exe with our script as the argument

$scriptPath = 'C:\Dropbox\Business Projects\Courses\Varonis\Learning PowerShell and How to Keep Active Directory Secure and Healthy\Modules\6. Building Reports with PowerShell\Demos\Invoke-ADHealthCheckReport.ps1'

## These are command switches to use when invoking scripts from cmd.exe
$psArgs = "-NonInteractive -NoProfile -File `"$scriptPath`""
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $psArgs

## Set the user that this task will be executed under. LogonType S4U runs whether a user is logged on or not
$principal = New-ScheduledTaskPrincipal -LogonType S4U -UserId 'MYLAB\administrator'

## Define optional settings. This is not mandatory
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable

## Create the scheduled task object. This doesn't actually create the task yet
$task = New-ScheduledTask -Action $action -Settings $settings -Principal $principal

## Finally create the task on the system
Register-ScheduledTask -InputObject $task -TaskName 'AD Health Check'