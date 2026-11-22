# Security design and control rationale

## Defender for Servers Plan 2
Provides the subscription-level Defender for Servers capability required by this lab's JIT and server-protection objectives. Optional plans such as Defender CSPM were left disabled because they were outside the stated requirements.

## Just-in-time VM access
JIT reduces persistent management-port exposure by allowing approved, time-bounded access requests. The lab requirement was RDP TCP 3389 with a maximum one-hour request duration.

Production considerations:
- Prefer Azure Bastion or private management connectivity over public RDP.
- Restrict request sources to approved administrator egress ranges where appropriate.
- Require strong MFA and privileged identity controls.
- Alert on JIT requests, approvals and policy changes.
- Disable unused management protocols.

## Key Vault network controls
The lab combined a Microsoft.KeyVault service endpoint on Subnet1-1, a selected-network firewall rule and default-deny behaviour.

These are distinct control layers:
- Network firewall determines whether the network path is allowed.
- Azure RBAC/access policies determine whether the caller may perform data-plane operations.
- Private endpoints provide private IP connectivity through Azure Private Link; they are not interchangeable with service endpoints.

## Purge protection
Purge protection helps prevent permanent deletion of a soft-deleted vault and its objects during the retention period. It is a destructive-lifecycle safeguard and cannot be disabled after activation. Align it with recovery and retention policy.

## Azure SQL private endpoint
The lab created a private endpoint in Subnet1-1 and verified its connection state as Approved. A production design must also configure the privatelink.database.windows.net private DNS zone and VNet links, verify client DNS, disable public access where appropriate, validate SQL authentication and monitor connection approvals.

## Guest Configuration
The extension provides the VM-side component for machine configuration assessment/management. Extension provisioning success is not complete compliance. Confirm managed identity, supported OS, extension health, machine configuration assignment and Defender recommendation status for every VM.
