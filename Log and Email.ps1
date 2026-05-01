function Monitor-ServiceHealth{
Param(
[parameter(mandatory = $true)]
[string[]]$ComputerName,
[string[]]$ServiceName,
[string]$LogPath,
[Switch]$SaveReport
)

$result=foreach($Computer in $ComputerName){
foreach($service in $ServiceName){
 $action = $null
 $currenttime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
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
    Timestamp=Get-Date -Format "yyyy-MM-dd HH:mm:ss"
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
Timestamp=$currenttime
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
Write-Warning "EMAIL ALERT WOULD BE SENT HERE"

$body = $failed | ConvertTo-Html | Out-String

$cred = New-Object System.Management.Automation.PSCredential (
    "rnkumaran103@gmail.com",
    (ConvertTo-SecureString "app password" -AsPlainText -Force)
)

Send-MailMessage `
 -To "navinkumaran20@gmail.com" `
 -From "rnkumaran103@gmail.com" `
 -Subject "ALERT: Service Failures Detected" `
 -Body $body `
 -BodyAsHtml `
 -SmtpServer "smtp.gmail.com" `
 -Port 587 `
 -UseSsl `
 -Credential $cred
 

if($SaveReport){$failed | Export-Csv $LogPath -Append -NoTypeInformation}
}
return $result

}
Monitor-ServiceHealth -ComputerName "Server1" -ServiceName "WinRM","Fax" -LogPath "C:\ServiceHealthHistory.csv" -SaveReport




