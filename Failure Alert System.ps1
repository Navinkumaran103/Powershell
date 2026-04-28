function Send-ServiceFailureAlert{
param(
[parameter(mandatory=$true)]
[string]$Path,
[Switch]$SaveReport
)

$data = Import-Csv $Path


$results=foreach($failure in $data | Where-Object ActionTaken -eq "FAILED"){
$action = $failure.Actiontaken

if($action -eq "FAILED"){

$failed   = $failure.Count
Write-Host "ALERT: $failed services failed!"

[PSCustomObject]@{
Service = $failure.Service
Status = $failure.Status
ActionTaken =$failure.ActionTaken
}
}

else {Write-Host "All monitored services are healthy"}

}

if($SaveReport){
$results | Export-Csv "C:\ServiceFailureReport.csv"
}
return $results
}

Send-ServiceFailureAlert -Path "C:\Users\Navinkumaran\Desktop\desktop files\UsersServiceMonitor.csv" -SaveReport




<#
function Send-ServiceFailureAlert{
param(
[parameter(mandatory=$true)]
[string]$Path,
[Switch]$SaveReport
)

$data = Import-Csv $Path
$data | Format-List *
$data.ActionTaken | ForEach-Object { "[$_]" }

##PowerShell returns an object, not a collection, unless it NEEDS to. @() forces it to always be a collection.

$failedServices = @($data | Where-Object {
    $_.ActionTaken -and $_.ActionTaken.Trim().ToUpper() -eq "FAILED"
})
Write-Host "Failed Count = $($failedServices.Count)"

if($failedServices.Count -gt 0){
Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
Write-Host "!!!!!!!!!!!ALERT: $($failedServices.Count) services failed!"
$failedServices | Format-Table Service, Status, ActionTaken
if($SaveReport){
$failedServices  | Export-Csv "C:\ServiceFailureReport.csv"
}
}
else {Write-Host "-----All monitored services are healthy"}

#return $failedServices
}

Send-ServiceFailureAlert -Path "C:\Users\Navinkumaran\Desktop\desktop files\UsersServiceMonitor.csv" -SaveReport

#>
