# hots resolution fixer upper

### Set your desired resolution here ###

# the desired resolution to run HotS at
$width  = "5120"
$height = "1440"

# the base path to the HotS program/app
$bnetRoot = 'C:\Program Files (x86)\Battle.net'


##### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING #####
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

# launch HOTS
Start-Process "$bnetRoot\Battle.net Launcher.exe" -ArgumentList '--exec="launch Hero"'
