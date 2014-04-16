
Param(
  [string]$name ,
  [string]$version
)
$temp_file = "_update.json"
if (Test-Path  (temp_file))
{
    del $temp_file
}
#delete temp file.
$j =  & knife environment show staging -F json
if($LASTEXITCODE -ne 0)
{
    throw "failed to get environment setting"
}
#IF Last exit code 
$ps = "[$j]" | ConvertFrom-Json
$ps.cookbook_versions | Add-Member -type NoteProperty -name $name -value "= $version" -force
$newJson = $ps | ConvertTo-Json -Compress
$newJson | Out-File update.json -Encoding UTF8
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
[System.IO.File]::WriteAllLines($temp_file, $newJson ,$Utf8NoBomEncoding)
& knife environment from file ".\$temp_file"
if($LASTEXITCODE -ne 0)
{
    throw "failed to upload environment setting"
}
