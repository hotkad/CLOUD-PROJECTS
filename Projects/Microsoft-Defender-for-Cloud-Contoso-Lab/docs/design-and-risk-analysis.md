# Defender for Cloud — Business Requirements, Design Decisions and Threat Model

## Business problem
A cloud workload environment needs a minimum set of controls to reduce exposed management ports, constrain access to sensitive secrets, protect against destructive vault deletion, and provide private connectivity to Azure SQL. The lab uses a least-change approach: implement only the controls required by the task.

## Business requirements
- Enable Defender for Servers Plan 2 at subscription scope.
- Restrict VM1 RDP exposure using Just-in-Time access with a one-hour maximum request.
- Allow Key Vault network access only from Subnet1-1 and deny other network paths.
- Enable Key Vault purge protection.
- Create an Azure SQL private endpoint and verify its connection state.
- Deploy Guest Configuration to the in-scope VMs and separately verify the Defender posture assessment.

## Architecture
The lab is scoped to Azure subscription / RG1, an existing VNet and Subnet1-1, VM1, a Key Vault, an Azure SQL logical server, and Defender for Cloud. Defender for Servers provides the JIT capability; Key Vault uses a subnet service endpoint and selected-network firewall rule; SQL uses a private endpoint and the recommended private DNS zone `privatelink.database.windows.net`.

## Security design decisions
| Decision | Rationale | Trade-off / residual risk |
|---|---|---|
| Enable only Defender for Servers Plan 2 | Meets the stated server-protection/JIT requirement without enabling unrelated paid plans | Other CSPM/workload plans remain outside this lab's scope |
| JIT for TCP 3389, one hour | Removes persistent RDP exposure and limits approved access duration | JIT does not replace private management access, MFA or privileged access governance |
| Key Vault selected network + default Deny | Restricts network path to the approved subnet | Network rules do not grant or deny data-plane permissions by themselves |
| Purge protection | Reduces risk of permanent deletion during soft-delete retention | Irreversible enablement; retention must align with recovery requirements |
| SQL private endpoint + private DNS | Keeps intended SQL access on private IP routing | Public network access remains enabled unless explicitly disabled after dependency testing |
| Guest Configuration status checked separately | Extension provisioning is not equivalent to compliance | Requires per-VM validation and recommendation/assessment confirmation |

## Threat model
| Threat | Impact | Control / evidence | Residual risk / next test |
|---|---|---|---|
| Internet scanning or brute force against RDP | VM compromise | JIT configured for TCP 3389, max one hour | Prefer Bastion/private admin path; test source restrictions and request expiry |
| Untrusted network reaches Key Vault | Secret/data exposure | Selected subnet rule and default Deny | Test from an unapproved subnet and validate identity RBAC separately |
| Accidental or malicious vault purge | Irrecoverable secret loss | Soft delete and purge protection | Test recovery workflow and monitor purge attempts |
| SQL traffic leaves private path | Data exposure or policy bypass | Private endpoint and private DNS integration | Resolve FQDN from approved client; verify private IP; disable public access only after validation |
| VM configuration drift | Persistent insecure settings | Guest Configuration extension and Defender recommendations | Verify every VM, assignment, compliance result and remediation |
| Excessive Defender plan scope/cost | Unplanned spend and data processing | Enable only required plan | Review subscription pricing, coverage and cost after deployment |

## Recorded outcome boundary
The source lab records Defender for Servers Plan 2, JIT, Key Vault network restrictions, purge protection and an Approved SQL private endpoint. Guest Configuration provisioning succeeded on VM1; the broader all-VM coverage and Defender posture/vulnerability check were not conclusively completed. Preserve that distinction in portfolio claims.

## Architecture decision records
- **ADR-01 — Minimum required Defender plan:** enable Servers Plan 2 only for this task; defer unrelated plans pending risk and cost approval.
- **ADR-02 — JIT rather than standing RDP:** use time-bounded access; prefer Bastion/private management in production.
- **ADR-03 — Network and data-plane controls are separate:** validate Key Vault network reachability and RBAC independently.
- **ADR-04 — Private endpoint requires DNS:** treat endpoint approval, DNS resolution and actual client routing as separate acceptance tests.
- **ADR-05 — Extension success is not compliance:** require per-VM extension state and Defender assessment evidence.
