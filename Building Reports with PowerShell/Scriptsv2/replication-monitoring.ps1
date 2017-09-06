function Invoke-ReplicationMonitor {
    param(
        [object[]]$DomainController
    )

    ## Gather up replication information for each DC and each parition on each DC
    $replData = Get-ADReplicationPartnerMetadata -Target $DomainController

    ## First create the output object's structure
    $output = @{}

    $replData.foreach({
        [pscustomobject]@{
            DomainController = $_.Server
            LastReplicationAttempt = $_.LastReplicationAttempt
            ReplicationStatus = if ($_.LastReplicationResult -eq 0) { 'Success' } else { 'Failure' }
        }
    })
}

