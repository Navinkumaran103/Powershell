function Monitor-ServiceHealth{
Param(
[parameter(mandatory = $true)]
[string[]]$ComputerName,
[string[]]$ServiceName,
[Switch]$SaveReport
)

$result=foreach($Computer in $ComputerName){
foreach($service in $ServiceName){
$status=$service.Status

if($status -eq "Running"){
$action = "OK"
}
else{
try{
Start-Service $service -ErrorAction Stop
$status=$service.Refresh()

if($status -eq "Running"){
$action = "Restarted"
}
else{$action = "FAILED"}
}
catch{
$action = "FAILED"
}

[PSCustomObject]@{
Computer=$Computer
Service=$service
Status=$status
ActionTaken=$action
}

}

}
}
$failed = @($result | Where-Object ActionTaken -eq "FAILED")
if($failed.ActionTaken -eq "FAILED"){
Write-Host "!!!!!!!!!!!!!ALERT!!!!!!!!!!!!!!"
if($SaveReport){Export-Csv "C:\multiserverservicefaillog.csv"}
}

}
Monitor-ServiceHealth -ComputerName "Server1", "Server2" -ServiceName "WinRM","Spooler", -SaveReport


<#
function Monitor-ServiceHealth{
Param(
[parameter(mandatory = $true)]
[string[]]$ComputerName,
[string[]]$ServiceName,
[Switch]$SaveReport
)

$result=foreach($Computer in $ComputerName){
foreach($service in $ServiceName){
 $action = $null
#$svc = Get-Service -ComputerName $Computer -Name $service
#$status=$svc.Status
try {
    $svc = Get-Service -ComputerName $Computer -Name $service -ErrorAction Stop
    $status = $svc.Status
}
catch {
    $status = "NotFound"
    $action = "FAILED"

    [PSCustomObject]@{
        Computer=$Computer
        Service=$service
        Status=$status
        ActionTaken=$action
    }
    continue
}

if($status -eq "Running"){
$action = "OK"
}
else{
try{
Start-Service -InputObject $svc -ErrorAction Stop
$svc.Refresh()
$status=$svc.Status

if($status -eq "Running"){
$action = "Restarted"
}
else{$action = "FAILED"}
}
catch{
$action = "FAILED"
}
}

[PSCustomObject]@{
Computer=$Computer
Service=$service
Status=$status
ActionTaken=$action
}



}
}
$failed = @($result | Where-Object ActionTaken -eq "FAILED")
if($failed.Count -gt 0){
Write-Warning "!!!!!!!!!!!!!ALERT: $($failed.Count) service failures detected!!!!!!!!!!!!!!!"
if($SaveReport){$failed | Export-Csv "C:\multiserverservicefaillog.csv" -Append -NoTypeInformation}
}
return $result

}
Monitor-ServiceHealth -ComputerName "localhost" -ServiceName "WinRM","Fax" -SaveReport

#>
