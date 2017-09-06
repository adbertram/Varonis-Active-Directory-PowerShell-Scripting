# Download RSAT from microsoft.com

$parameters = @{
    Uri = 'https://download.microsoft.com/download/1/8/E/18EA4843-C596-4542-9236-DE46F780806E/Windows8.1-KB2693643-x64.msu'
    OutFile = "C:\Windows8.1-KB2693643-x64.msu"
}
Invoke-WebRequest @parameters

Test-Path -Path "C:\Windows8.1-KB2693643-x64.msu"

## Install RSAT

wusa.exe /install C:\Windows8.1-KB2693643-x64.msu /norestart

## Confirm RSAT shows up in Programs/Features
appwiz.cpl 