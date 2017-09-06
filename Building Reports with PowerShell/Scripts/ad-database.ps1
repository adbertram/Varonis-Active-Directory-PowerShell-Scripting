function Invoke-ADDatabaseInfo {
    ## Pull information from the registry over a remoting session. All the code is ran inside of a scriptblock
    ## which will be ran locally on each remote system

    $scriptBlock = {
        $database = Get-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\NTDS\Parameters
        $dbFilePath = $database.'DSA Database File'
        $dbSize = (Get-ItemProperty $dbFilePath).Length / 1MB

        $dbDiag = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics
        $whiteSpaceLoggingEnabled = $dbDiag.'6 Garbage Collection'
        if ($whiteSpaceLoggingEnabled -eq 1) {
            $whiteSpaceLoggingEnabled = $true
        } elseif ($whiteSpaceLoggingEnabled -eq 0) {
            $whiteSpaceLoggingEnabled = $false
        }
    
        ## Output the custom object
        [pscustomobject]@{
            DomainController = (hostname)
            DBFilePath = $dbfilepath
            DBSize = $dbSize
            WhiteSpaceLoggingEnabled = $whiteSpaceLoggingEnabled
        }
    }

    ## just a single Invoke-Command
    $results = Invoke-Command -ComputerName 'DC','MEMBERSRV1' -ScriptBlock $scriptBlock -HideComputerName
    $results = $results | Select-Object -Property * -ExcludeProperty RunspaceId
    $results
}