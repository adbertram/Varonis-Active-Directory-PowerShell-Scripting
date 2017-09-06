function Get-VaronisGroup {
    param(
        [string[]]$Properties = 'Members'
    )

    $groups = Get-AdGroup -Filter * -Properties $Properties

    $groups.foreach({
        ## Create a hashtable to store properties in temporarily for each $group
        $output = @{}
        ## Begin assigning keys to the hashtable
        $output.GroupName = $_.Name
        ## Capture all of the group members
        $groupMembers = Get-ADGroupMember -Identity $_ | Where { $_.ObjectClass -eq 'User' } | Select-Object -ExpandProperty Name
        ## Only output a custom object if there were members in that group
        if ($groupMembers) {
            $output.Members = $groupMembers
            [pscustomobject]$output
        }
    })
}