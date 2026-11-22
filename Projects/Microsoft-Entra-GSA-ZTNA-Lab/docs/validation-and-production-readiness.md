# GSA ZTNA — Validation Matrix and Production Readiness

## Lab validation matrix

| Test | Endpoint / identity | Expected result | Recorded result |
|---|---|---|---|
| T1 — Resolve admin.labcorp.local via private DNS | CLIENT02 / labadmin | Resolve through GSA to DC01/private APP01 address | Pass |
| T2 — Open ADUC and browse OUs | CLIENT02 / labadmin | Full access without RPC timeout | Pass |
| T3 — Access all three web portal segments | CLIENT02 / labadmin | Allowed because assigned | Pass |
| T4 — Open ADUC | CLIENT01 / jdean | Legacy domain/network path allowed | Pass |
| T5 — Access web portal segments | CLIENT01 / jdean | Blocked by NIC-scoped NSG | Pass |
| T6 — Attempt ADUC | CLIENT03 / testdeny | AADSTS50105 | Pass |
| T7 — Attempt each web portal | CLIENT03 / testdeny | AADSTS50105 | Pass |
| T8 — Disconnect GSA and retry private FQDN | CLIENT02 / labadmin | Unreachable; no direct network path | Pass |
| T9 — Verify CA signalling | GSA-connected sessions | Sign-in logs reflect GSA client network location | Pass |
| T10 — RPC regression test | CLIENT02 / labadmin | ADUC object property edit completes | Pass |

## Production readiness gaps

The capstone is a working lab demonstration, not a production-ready design. The source report explicitly identifies these improvements:

### Identity and endpoint posture
- Deploy the GSA client through Intune with a pilot ring, robust detection, install logging and rollback.
- Treat Intune MDM enrollment prerequisites and Conditional Access interactions as documented tenant baseline configuration.
- Add device compliance policies (BitLocker, supported OS/patch level, Defender health) and require compliant-device state where appropriate.
- Use governed group-based assignment, access packages and periodic access reviews rather than ad hoc direct assignment.

### Connector resilience
- Deploy at least two Private Network Connectors per connector group in each production site.
- Monitor connector health and capacity; test failover and planned maintenance.
- Do not treat the lab's single connector as a high-availability topology.

### Segmentation and protocol exposure
- Publish only required application destinations, ports and protocols.
- Keep application segments narrow and separately scoped per app.
- Review the AD/RPC dynamic port range carefully. Where broad dynamic ranges are required, assess alternatives such as constrained RPC ranges on servers and strict connector/network segmentation.
- Ensure no alternate peering, route, VPN or firewall path bypasses the intended identity-aware enforcement point.

### Conditional Access and governance
- Distinguish Private Access application assignment from Internet Access Security Profile policy.
- Extend Conditional Access with appropriate device, sign-in risk, location and session controls.
- Use access reviews and approval workflows for privileged or sensitive app assignments.
- Monitor sign-in, traffic and connector logs; define alerting and incident ownership.

### Migration and cutover
- Run Private Access alongside existing VPN access per application during migration.
- Use GSA traffic telemetry to verify usage and identify legacy paths before decommissioning VPN/firewall rules.
- Maintain a tenant-alignment checklist for imported Azure VMs and devices.
- Validate Universal Conditional Access support against current product capabilities; do not assume it applies to Private Access tunnels.

## Important scope caveats
- The lab used one connector and a small test population.
- The source report's test identity/app matrix evolved during the build; the final matrix above reflects its recorded end state.
- A successful local RDP session with a local administrator does not demonstrate Entra-based VM sign-in.
- The lab's RPC range and client registry settings are not blanket recommendations for production.
- Product portal names, licensing requirements and supported Conditional Access features change; verify current Microsoft documentation before implementation.

## Microsoft references
- [Microsoft Entra Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/)
- [Microsoft Entra Private Access](https://learn.microsoft.com/entra/global-secure-access/how-to-configure-connectors)
- [Global Secure Access client](https://learn.microsoft.com/entra/global-secure-access/how-to-install-windows-client)
- [Intune Win32 app management](https://learn.microsoft.com/mem/intune/apps/apps-win32-app-management)
- [Conditional Access](https://learn.microsoft.com/entra/identity/conditional-access/overview)
- [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/powershell/microsoftgraph/overview)
