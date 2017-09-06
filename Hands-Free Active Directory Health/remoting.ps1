## PowerShell remoting must be enabled and available on remote systems

## For individual systems --A GPO can be setup to enable PS remoting across many systems
Enable-PSRemoting -Force

## PS remoting creates a session on the remote system to then run commands on.
$session = New-PSSession -ComputerName DC
$session

Get-PSSession
Get-PSSession | Remove-PSSession

## We can now use this session over and over again. Everything is held on the remote system
Invoke-Command -Session $session -ScriptBlock { hostname }

help Invoke-Command

## Creating a full session is great if you intend to perform multiple actions on the remote system
## However, not so great just to perform one. Instead, just specify a computer name and a temp session will be created
Invoke-Command -ComputerName DC -ScriptBlock {hostname}

## Can perform remote commmands over many computers at once
Invoke-Command -ComputerName DC,MEMBERSRV1 -ScriptBlock { hostname }