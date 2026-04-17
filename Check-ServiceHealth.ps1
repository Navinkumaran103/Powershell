function check-ServiceHealth {
param(
[parameter(mandatory = $true)] 
[string[]]$Servicename,
[switch]$Log
)
$services=Get-Service -name $Servicename

foreach($service in $services){
$status = $service.Status

if($status -eq "Running"){
[PSCustomObject]@{
"Service" = $service.Name
Status = $status
Actiontaken = "OK"}
}

elseif($status -eq "Stopped"){
try{
 Start-Service $service -ErrorAction Stop
 $service.Refresh()
 $status = $service.Status

 if($status -eq "Running"){
 [PSCustomObject]@{
 "Service" = $service.Name
 Status = $status
 Actiontaken = "Restarted"}
 }
 else{
 [PSCustomObject]@{
 "Service" = $service.Name
 Status = $status
 Actiontaken = "FAILED"}
 }
}
catch{Actiontaken = "FAILED"}

}
}
if($Log){output-file "C:\ServiceMonitorLog.txt"}
}

check-ServiceHealth -Servicename BITS,spooler



<#
function Check-ServiceHealth {

param(
    [Parameter(Mandatory = $true)]
    [string[]]$ServiceName,

    [switch]$Log
)

$results = foreach($service in Get-Service -Name $ServiceName){

    $status = $service.Status

    if ($status -eq "Running") {
        $action = "OK"
    }
    else {
        try {
            Start-Service $service -ErrorAction Stop
            $service.Refresh()
            $status = $service.Status

            if ($status -eq "Running") {
                $action = "Restarted"
            }
            else {
                $action = "FAILED"
            }
        }
        catch {
            $action = "FAILED"
        }
    }
    [PSCustomObject]@{
        Service     = $service.Name
        Status      = $status
        ActionTaken = $action
    }
}
if ($Log) {
    $results | Out-File "C:\ServiceMonitorLog.txt" -Append
   #$results | Export-Csv "$env:USERPROFILE\ServiceMonitor.csv" -Append -NoTypeInformation


}
return $results
}

Check-ServiceHealth -ServiceName BITS,Spooler -Log
#>
