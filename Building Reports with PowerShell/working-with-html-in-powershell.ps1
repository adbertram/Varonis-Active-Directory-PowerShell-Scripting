## ConvertTo-Html defaults to creating a HTML table element
$services = Get-Service | Select-Object Status, Name, DisplayName
$servicesHtml = $services | ConvertTo-HTML
$servicesHtml

## Save to a file to store results
$servicesHtml | Out-File C:\Services.htm

## Use Invoke-Expression to open the HTM file with the associated program (Internet Explorer)
Invoke-Expression C:\Services.htm

## ConvertTo-Html has options to manipulate the HTML
$services | ConvertTo-HTML -Title 'Windows Services' | Out-File C:\Services.htm
Get-Help ConvertTo-Html
Invoke-Expression C:\Services.htm

## Adding CSS to pretty up the report
$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
"@
$services | ConvertTo-HTML -Title 'Windows Services' -Head $header | Out-File C:\Services.htm
Invoke-Expression C:\Services.htm

## Finishing the report off with pre and post content
$preContent = "Windows service report for computer: $(hostname)"
$postContent = "Found $($services.Count) total services"

## Splatting
$convertHtmlParams = @{
    Title = 'Windows Services'
    Head = $header
    PreContent = $preContent
    PostContent = $postContent
}
$services | ConvertTo-HTML @convertHtmlParams | Out-File C:\Services.htm
Invoke-Expression C:\Services.htm