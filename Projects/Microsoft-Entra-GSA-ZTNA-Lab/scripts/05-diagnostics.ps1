# Run from the relevant Windows endpoint.
Write-Host "=== Device registration ==="
dsregcmd /status
Write-Host "=== Private DNS ==="
Resolve-DnsName finance.labcorp.local -ErrorAction Continue
nslookup finance.labcorp.local
Write-Host "=== DNS client configuration ==="
Get-DnsClientServerAddress
Write-Host "=== DC01 LDAP reachability ==="
Test-NetConnection 172.16.0.5 -Port 389
Write-Host "=== APP01 HTTP reachability ==="
Test-NetConnection 172.16.0.10 -Port 80
Write-Host "=== RSAT capability ==="
Get-WindowsCapability -Online -Name "Rsat.ActiveDirectory*"
