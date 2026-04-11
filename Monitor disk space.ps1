
$free = Get-CimInstance Win32_LogicalDisk | Select-Object -Property @{name="Free%";expression={($_.Freespace/$_.Size)*100 -as [int]}}
$status=if($free.'Free%' -lt 20) { "LOW SPACE"} ELSE {"HEALTHY"}

Get-CimInstance Win32_LogicalDisk | Select-Object -Property @{name="Drive";expression={$_.DeviceID}}, 
@{name="Size(GB)";expression={$_.Size/1GB -as [int]}},
@{name="Free(GB)";expression={$_.Freespace/1GB -as [int]}},
@{name="Free%";expression={($_.Freespace/$_.Size)*100 -as [int]   }},@{name="Status";expression={$status}}

<#
$disks = Get-CimInstance Win32_LogicalDisk | Where-Object DriveType -eq 3

foreach ($disk in $disks) {

    if ($disk.Size -ne 0) {

        $sizeGB  = [int]($disk.Size / 1GB)
        $freeGB  = [int]($disk.FreeSpace / 1GB)
        $freePct = [int](($disk.FreeSpace / $disk.Size) * 100)

        if ($freePct -lt 20) {
            $status = "LOW SPACE"
        }
        else {
            $status = "HEALTHY"
        }

        [PSCustomObject]@{
            Drive     = $disk.DeviceID
            "Size(GB)" = $sizeGB
            "Free(GB)" = $freeGB
            "Free %"   = "$freePct%"
            Status    = $status
        }
    }
}
#>


 amkq lxwy aocc uadr
