function Invoke-ReplicationMonitor {

    ## Gather up replication information for each DC and each parition on each DC
    $replData = Get-ADReplicationPartnerMetadata -Target 'DC','MEMBERSRV1'

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

