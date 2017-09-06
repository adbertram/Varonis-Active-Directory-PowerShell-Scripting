$demoPath = 'C:\Dropbox\Business Projects\Courses\Varonis\Learning PowerShell and How to Keep Active Directory Secure and Healthy\Modules\4. Interrogating Active Directory\Demos'

## Scripts are extremely common in PowerShell
## A script is just a text file with a PS1 extension
ise "$demoPath\script.ps1"

## They can be executed as you'd expect
## Either by invoking the PowerShell engine
powershell.exe -File "$demoPath\script.ps1"

## or directly from the console
& "$demoPath\script.ps1"

## Scripts are little bundles of code in a file but are still a file
## Where'd I put that script? What does it do again?
## We need to do the same thing only from within PowerShell itself.

function Do-Thing {
    Write-Output 'I did the thing!'
}

## The function must be "loaded" into an existing PowerShell session
## It can then be called just like a script

Do-Thing

## over and over.. no more worrying about files
Do-Thing
Do-Thing

## Functions are "bundles" of code that have inputs and outputs

$outputOfFunction = Do-Thing
$outputOfFunction -eq 'I did the thing!'

## Do-Thing has no inputs. Let's create an input
function Do-Thing {
    param(
        [Parameter()]
        $Attribute
    )

    Write-Output "I did the thing with $Attribute!"
}

$outputOfFunction = Do-Thing -Attribute 'whatever'
$outputOfFunction

## Working together in a single script
ise "$demoPath\ScriptWithFunctions.ps1"

& "$demoPath\ScriptWithFunctions.ps1"
