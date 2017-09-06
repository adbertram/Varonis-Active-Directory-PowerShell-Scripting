#region Setup
$scriptsPath = 'C:\Dropbox\Business Projects\Courses\Varonis\Learning PowerShell and How to Keep Active Directory Secure and Healthy\Modules\6. Building Reports with PowerShell\Demos\Scriptsv2'
$htmlFilePath = 'C:\ADHealthCheck.htm'

$reportTitle = 'Active Directory Health Check Report'

## Dot source all scripts
(Get-ChildItem -Path $scriptsPath).foreach({ . $_.FullName })

## Define common parameters up front to alleviate repeating ourselves

$properties = @(
    '*'
    'msDS-UserPasswordExpiryTimeComputed'
)
$adUsers = Get-AdUser -Filter "Enabled -eq 'True'" -Properties $properties

$dcs = Get-ADDomainController -Filter *
#endregion

#region Function parameter declarations
$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
"@

$sectionSeparator = '<br>--------------'
$sections = @(
    @{
        FunctionName = 'Get-ObjectCounts'
        FunctionParams = @{ Users = $adUsers; DomainController = $dcs }
        ConvertHtmlParams = @{
            Title = $reportTitle
            PreContent = $reportTitle
            PostContent = '<br>'
            Head = $Header ## Only needed for the section that creates the initial report
            As = 'List'
        }
        OutFileParams = @{
            FilePath = $htmlFilePath
        }
    }
    @{
        FunctionName = 'Invoke-DCDiag'
        FunctionParams = @{ DomainController = $dcs }
        ConvertHtmlParams = @{
            Fragment = $true
            PreContent = "DCDiagTestResults$sectionSeparator"
            PostContent = '<br>'
        }
        OutFileParams = @{
            FilePath = $htmlFilePath
            Append = $true
        }
    }
    @{
        FunctionName = 'Invoke-ReplicationMonitor'
        FunctionParams = @{ DomainController = $dcs }
        ConvertHtmlParams = @{
            Fragment = $true
            PreContent = "Replication Status$sectionSeparator"
            PostContent = '<br>'
        }
        OutFileParams = @{
            FilePath = $htmlFilePath
            Append = $true
        }
    }
    @{
        FunctionName = 'Invoke-ADDatabaseInfo'
        FunctionParams = @{ DomainController = $dcs }
        ConvertHtmlParams = @{
            Fragment = $true
            PreContent = "Database Status$sectionSeparator"
            PostContent = '<br>'
            Property = @('DomainController','DBFilePath','DBSize','WhiteSpaceLoggingEnabled')
        }
        OutFileParams = @{
            FilePath = $htmlFilePath
            Append = $true
        }
    }
)

#endregion

#region Run each function gathering data to build the report

$sections.foreach({
    $functionParams = $_.FunctionParams
    $convertHtmlParams = $_.ConvertHtmlParams
    $outFileParams = $_.OutFileParams
    & $_.FunctionName @functionParams | ConvertTo-Html @convertHtmlParams | Out-File @outFileParams
})

#endregion

## Read the HTML from the report
$emailBody = Get-Content -Path $htmlFilePath -Raw

Send-MailMessage -To adam@adamtheautomator.com -Subject 'AD Health Check Report' -BodyAsHtml -Body $emailBody -From me@example.com -SmtpServer smtp.example.com