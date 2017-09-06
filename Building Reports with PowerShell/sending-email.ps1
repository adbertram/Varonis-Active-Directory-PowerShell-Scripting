## Craft the email

$htmlFilePath = 'C:\ADHealthCheck.htm'

## Read the HTML from the report
$emailBody = Get-Content -Path $htmlFilePath -Raw

## Confirm the email body looks OK
$emailBody

 ## Run to ensure it works
 Send-MailMessage -To adam@adamtheautomator.com -Subject 'AD Health Check Report' -BodyAsHtml -Body $emailBody -From me@example.com -SmtpServer smtp.example.com

 ## Incorporate the email into the AD health check report with an option to disable