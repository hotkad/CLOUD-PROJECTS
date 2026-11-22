# Run on DC01 after confirming the labcorp.local DNS zone exists.
$Zone = "labcorp.local"
$Records = @(
    @{ Name="finance"; Address="172.16.0.10" },
    @{ Name="hr"; Address="172.16.0.10" },
    @{ Name="admin"; Address="172.16.0.10" }
)
foreach ($Record in $Records) {
    $Existing = Get-DnsServerResourceRecord -ZoneName $Zone -Name $Record.Name -RRType A -ErrorAction SilentlyContinue
    if (-not $Existing) {
        Add-DnsServerResourceRecordA -ZoneName $Zone -Name $Record.Name -IPv4Address $Record.Address
    } else {
        Write-Warning "A record $($Record.Name) already exists. Review before changing it."
    }
}
