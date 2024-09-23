# hots resolution fixer upper

[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $Setup,

    [Parameter()]
    [switch]
    $Remove
)

### Set your desired resolution here ###

# the desired resolution to run HotS at
$width  = "5120"
$height = "1440"

# the base path to the HotS program/app
$bnetRoot = 'C:\Program Files (x86)\Battle.net'

##### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING #####

"start args: $($args -join "`n" | Out-String)" *>> c:\temp\bnet.txt

# setup creates an Image File Execution entry that runs the script each time
if ($Setup.IsPresent) {
    ### VARIABLES ###
    # the process name used by HotS
    $processName = "Heroes of the Storm"

    # reg path to Image File Execution Options (IFEO)
    $ifeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

    # create the IFEO key name
    $ifeoKeyName = "$processName`.exe"

    # the full path to the process's IFEO values
    $ifeoFullPath = "$ifeoPath\$ifeoKeyName"

    # build the path to the script
    $fixScriptPath = "$PSScriptRoot\Fix-HotSRez.ps1"

    ### DO THE WORK ###
    # setup requires admin access to modify the registry
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ( $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $false) {
        throw "Setup must be run as administrator. Restart PowerShell as administrator and try again."
    }

    # check for an existing IFEO value
    $ifeoItem = Get-ItemProperty -Path $ifeoFullPath -Name Debugger -EA SilentlyContinue

    # create/set the IFEO debugger value
    if (-NOT $ifeoItem) {
        # create the initial value as an empty string
        try {
            # create the registry key
            $null = New-Item $ifeoFullPath -Force -EA Stop

            # add the Debugger value
            $null = New-ItemProperty -Path $ifeoFullPath -Name Debugger -PropertyType String -Value "" -Force -EA Stop
        } catch {
            throw "Failed to create the IFEO item. Error: $_"
        }
    }
    
    # set the value to the current PSScriptRoot
    try {
        $cmd = "powershell.exe -NoLogo -NoProfile -WindowStyle Hidden -File '$fixScriptPath'"
        $null = Set-ItemProperty -Path $ifeoFullPath -Name Debugger -Value $cmd -Force -EA Stop
    } catch {
        throw "Failed to set the IFEO debugger value for $processName. Error: $_"
    }
    
    # exit the script
    return $null
}

if ($Remove.IsPresent) {
    ### VARIABLES ###
    # the process name used by HotS
    $processName = "Heroes of the Storm"

    # reg path to Image File Execution Options (IFEO)
    $ifeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

    # create the IFEO key name
    $ifeoKeyName = "$processName`.exe"

    # the full path to the process's IFEO values
    $ifeoFullPath = "$ifeoPath\$ifeoKeyName"

    ### DO THE WORK ###
    # setup requires admin access to modify the registry
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ( $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $false) {
        throw "Setup must be run as administrator. Restart PowerShell as administrator and try again."
    }

    # check for an existing IFEO value
    $ifeoItem = Get-Item -Path $ifeoFullPath -EA SilentlyContinue

    if ($ifeoItem) {
        # delete the key
        try {
            $null = Remove-Item $ifeoItem.PSPath -Recurse -Force -EA Stop
        } catch {
            throw "Failed to remove the IFEO key. Error: $_"
        }
    }
    
    return $null
}

### edit the variables file ###
# get the user Documents path in a manner that will take into account OneDrive integration with the user profile.
$varPath = "$([System.Environment]::GetFolderPath("MyDocuments"))\Heroes of the Storm"

# encoding type of Variables.txt is UTF-8
$varEncoding = [System.Text.UTF8Encoding]::new()

# throw an error if the HotS\Variables.txt does not exist
try {
    $varFile = Get-Item "$varPath\Variables.txt" -EA Stop
} catch {
    throw "Could not find Variables.txt. Please run Heroes of the Storm at least once before running this script."
}

# stores the file contents
$file = [System.Collections.Generic.List[string]]::new()

# edit the file
switch -Regex -File $varFile {
    "^height=\d+$" { $file.Add("height=$height") }
    "^width=\d+$"  { $file.Add("width=$width") }
    default        { $file.Add($_) }
}

# write the updated file
try {
    # clear the file
    $null = Clear-Content $varFile -Force -EA Stop

    # open the file for writing
    $fileStream = $varFile.OpenWrite()

    # create the stream writer
    $streamWriter = [System.IO.StreamWriter]::new($fileStream, $varEncoding)

    foreach ($line in $file) {
        $streamWriter.WriteLine($line)
    }
} catch {
    throw "Failed to save Variables.txt. Error: $_"
} finally {
    # close the file and stream writer
    $streamWriter.Dispose()
    $fileStream.Dispose()
}

"end args: $($args -join "`n" | Out-String)" *>> c:\temp\bnet.txt

# launch HOTS
Start-Process "$bnetRoot\Battle.net Launcher.exe" -ArgumentList '--exec="launch Hero"'