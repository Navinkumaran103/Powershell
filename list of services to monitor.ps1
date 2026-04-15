$services = Get-Service -name BITS,Spooler,wuauserv


foreach ($service in $services){
$status = $service.Status

if($status -eq "Running") {

[PSCustomObject]@{
"Service" = $service.Name
Status = $status
Actiontaken = "OK"}

}

elseif($status -eq "Stopped"){

Start-Service $service

if($status -eq "Running"){
$service.Refresh()
$status = $service.Status
[PSCustomObject]@{
"Service" = $service.Name
Status = $status
Actiontaken = "Restarted"}

}
else {
[PSCustomObject]@{
"Service" = $service.Name
Status = $status
Actiontaken = "FAILED"}

}}} | Out-File -Append "C:\ServiceMonitorLog.txt"

<#
$services = Get-Service -Name BITS,Spooler,wuauserv 

foreach ($service in $services){

    $status = $service.Status

    if ($status -eq "Running") {

        [PSCustomObject]@{
            Service = $service.Name
            Status = $status
            ActionTaken = "OK"
        }

    }
    elseif ($status -eq "Stopped") {

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

        [PSCustomObject]@{
            Service = $service.Name
            Status = $status
            ActionTaken = $action
        }
    }
} | Out-File -Append "C:\ServiceMonitorLog.txt"

#>
