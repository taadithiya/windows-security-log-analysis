# Windows Security Event Log Export
# Exports Security logs from the previous 7 days

$logFolder = "D:\CYBERCRIT-ECOSYSTEM\CyberCrit-Labs\Windows-Log-Analysis\Local-Logs"
$outputFile = Join-Path $logFolder "Security.csv"

if (-not (Test-Path -Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

$startDate = (Get-Date).AddDays(-7)

try {
    Get-WinEvent -FilterHashtable @{
        LogName   = "Security"
        StartTime = $startDate
    } -ErrorAction Stop |
    Select-Object `
        TimeCreated,
        Id,
        LevelDisplayName,
        ProviderName,
        MachineName,
        Message |
    Export-Csv `
        -Path $outputFile `
        -NoTypeInformation `
        -Encoding UTF8

    Write-Host ""
    Write-Host "Security logs exported successfully."
    Write-Host "CSV path: $outputFile"
}
catch {
    Write-Host ""
    Write-Host "Export failed."
    Write-Host "Run PowerShell as Administrator."
    Write-Host "Error: $($_.Exception.Message)"
}