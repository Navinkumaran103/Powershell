function Get-ServiceFailures{
param(
[parameter(mandatory=$true)]
[String[]] $Path,
[Switch]$summary
)

$Loglines=Get-Content $Path
$logobject = foreach($lines in $Loglines){
$data = $lines.Split(" ")

[PSCustomObject]@{
$Action=$data[2].Trim()}

if($Action -eq "FAILED"){
[PSCustomObject]@{
Service=$data[0].Trim()
Status=$data[1].Trim()
Actiontaken=$data[2].Trim()
}
}
$logobject | Format-Table

if($summary){$logobject | Out-File "C:\ServiceMonitor.txt" -Append}
}

return $logobject
}

Get-ServiceFailures -Path "C:\ServiceMonitorLog.txt" -summary








<#
function Get-ServiceFailures {

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [switch]$Summary
)

$data = Import-Csv $Path

$failures = $data | Where-Object ActionTaken -eq "FAILED"

$failures

if ($Summary) {
    $total    = $data.Count
    $failed   = $failures.Count
    $success  = $total - $failed

    Write-Host "`nSummary"
    Write-Host "--------"
    Write-Host "Total Entries: $total"
    Write-Host "Failures: $failed"
    Write-Host "Success: $success"
}
}


#>
