## Start the ISE and show around
ise

## Let's build a simple script that first checks to see if a list of computers are online and, only if so,
## will attempt to find their operating system

Get-Content -Path C:\Example.txt | ForEach-Object {
    if (Test-Connection -ComputerName $_ -Quiet -Count 1) {
        Get-CimInstance -ComputerName $_ -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty Caption
    }
}

## This could be copied and pasted into the console

## but it'd be a lot easier if we'd just create a script to run it. Using a script, we could also build script parameters
## to allow us to dynamically pass in different file names in case it's not always C:\Example.txt