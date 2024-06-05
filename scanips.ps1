
$file = Read-Host "Enter the file path"


if (-not (Test-Path $file)) {
    Write-Host "File not found. Please enter a valid file path."
    exit
}


$ips = Get-Content $file


function Get-AbuseIPReport {
    param(
        [string]$ip
    )

    
    $apiKey = "YOUR-API_KEY"
    $url = "https://api.abuseipdb.com/api/v2/check"
    $headers = @{
        "Key" = $apiKey
    }
    $body = @{
        "ipAddress" = $ip
    }
    $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -Body $body

    
    if ($response.data.abuseConfidenceScore -gt 0) {
        Write-Host "IP Address: $($response.data.ipAddress)"
        Write-Host "Reported: Yes"
        Write-Host "Abuse Confidence Score: $($response.data.abuseConfidenceScore)"
        Write-Host "Total Reports: $($response.data.totalReports)"
        Write-Host "Last Reported At: $($response.data.lastReportedAt)"
        Write-Host "Reports: $($response.data.reports)"
        Write-Host "Country Code: $($response.data.countryCode)"
        Write-Host "Usage Type: $($response.data.usageType)"
        Write-Host "ISP: $($response.data.isp)"
        Write-Host "Domain: $($response.data.domain)"
        Write-Host "-----------------------------------"
    } else {
        Write-Host "IP Address: $($response.data.ipAddress)"
        Write-Host "Reported: No"
        Write-Host "-----------------------------------"
    }
}


foreach ($ip in $ips) {
    Get-AbuseIPReport -ip $ip
}
