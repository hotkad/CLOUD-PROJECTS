# Evidence register

No screenshots or raw Azure exports are currently committed here. Capture evidence from the actual lab; do not fabricate deployment screenshots.

## Evidence to capture
| ID | Evidence | Required validation |
|---|---|---|
| DFC-01 | Defender for Servers Plan 2 pricing state | Standard tier / P2 at subscription scope |
| DFC-02 | JIT configuration for VM1 | TCP 3389; maximum request duration one hour |
| DFC-03 | Key Vault network configuration | Subnet1-1 selected; default action Deny |
| DFC-04 | Key Vault purge protection | Enabled in vault properties |
| DFC-05 | SQL private endpoint connection | Connection state Approved |
| DFC-06 | SQL private DNS zone and client resolution | `privatelink.database.windows.net`; client resolves server FQDN to private endpoint |
| DFC-07 | Guest Configuration | Extension provisioning state and Defender assessment for each in-scope VM |

## Naming and handling
Use `DFC-01-defender-plan.png` etc. Record timestamp, resource alias, expected result, observed result and outstanding caveat. Redact subscription/resource IDs, tenant identifiers, public IPs, UPNs and secrets.
