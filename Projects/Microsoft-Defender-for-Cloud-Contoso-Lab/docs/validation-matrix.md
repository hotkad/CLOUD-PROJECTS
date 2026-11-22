# Validation matrix

| ID | Control | Verification evidence | Source-lab status |
|---|---|---|---|
| V-01 | Defender for Servers Plan 2 | az security pricing show; tier Standard, subplan P2 | Passed |
| V-02 | JIT on VM1 | Defender for Cloud → JIT → Configured; RDP 3389; max 1 hour | Configured on second attempt |
| V-03 | Key Vault subnet restriction | Selected networks; Subnet1-1 rule; default action Deny | Passed |
| V-04 | Purge protection | Key Vault Properties shows enabled | Passed |
| V-05 | SQL private endpoint | Private endpoint connection state Approved | Passed |
| V-06 | Guest Configuration | Extension list; ConfigurationforWindows provisioning Succeeded on VM1 | VM1 succeeded; all-VM coverage and Defender posture not fully evidenced |

## Additional tests recommended
- From Subnet1-1, confirm Key Vault network path and intended identity permissions.
- From a non-approved network, confirm Key Vault access is denied.
- Resolve the SQL server FQDN from the linked VNet and verify it resolves to the private endpoint IP.
- Disable SQL public access only after confirming all dependencies use the private route.
- Verify extension deployment for every VM; record OS, identity assignment, version and provisioning state.
- Confirm Defender recommendation and machine-configuration compliance after evaluation.
- Confirm JIT requests expire within the configured maximum and no unnecessary permanent RDP rule remains.

## Evidence handling
Capture portal state and CLI output with timestamps. Redact subscription IDs, resource IDs, public IPs, tenant identifiers, UPNs and access tokens before publishing.
