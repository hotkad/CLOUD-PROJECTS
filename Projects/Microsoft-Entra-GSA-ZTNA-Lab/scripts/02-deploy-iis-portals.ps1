# Deploy three IIS host-header sites on APP01. Run elevated in a disposable lab.
# Hostnames align with architecture.md and scripts/03-private-dns-records.ps1.
Import-Module WebAdministration -ErrorAction Stop
$Sites = @(
    @{ Name="Portal-Finance"; Host="finance.labcorp.local"; Path="C:\inetpub\portal-finance" },
    @{ Name="Portal-HR"; Host="hr.labcorp.local"; Path="C:\inetpub\portal-hr" },
    @{ Name="Portal-Admin"; Host="admin.labcorp.local"; Path="C:\inetpub\portal-admin" }
)
foreach ($Site in $Sites) {
    New-Item -ItemType Directory -Path $Site.Path -Force | Out-Null
    $Html = @"
<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>$($Site.Name)</title></head>
<body style="font-family:Segoe UI,sans-serif;margin:4rem">
<h1>$($Site.Name)</h1><p>LabCorp internal portal — Private Access validation page.</p>
</body></html>
"@
    Set-Content -Path (Join-Path $Site.Path "index.html") -Value $Html -Encoding UTF8
    $Pool = "$($Site.Name)-Pool"
    if (-not (Test-Path "IIS:\AppPools\$Pool")) {
        New-WebAppPool -Name $Pool | Out-Null
        Set-ItemProperty "IIS:\AppPools\$Pool" -Name managedRuntimeVersion -Value ""
    }
    if (-not (Get-Website -Name $Site.Name -ErrorAction SilentlyContinue)) {
        New-Website -Name $Site.Name -PhysicalPath $Site.Path -ApplicationPool $Pool -Port 80 -HostHeader $Site.Host | Out-Null
    } else {
        Write-Warning "Website $($Site.Name) already exists; review its binding rather than overwriting it."
    }
}
Write-Host "IIS portal deployment attempted. Verify site state, bindings, DNS and HTTP response before marking complete."
