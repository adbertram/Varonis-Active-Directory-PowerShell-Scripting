function Invoke-ReplicationMonitor {
    param()
    ## Find each DC in the current domain
    $dcs = Get-ADDomainController -Filter *

    ## Gather up replication information for each DC and each parition on each DC
    $replData = Get-ADReplicationPartnerMetadata -Target $dcs

    ## First create the output object's structure
    $output = @{}

    $replData.foreach({
        $output[$_.Server] = @{
            LastReplicationAttempt = $_.LastReplicationAttempt
            ReplicationStatus = if ($_.LastReplicationResult -eq 0) { 'Success' } else { 'Failure' }
        }
    })
    [pscustomobject]$output
}

