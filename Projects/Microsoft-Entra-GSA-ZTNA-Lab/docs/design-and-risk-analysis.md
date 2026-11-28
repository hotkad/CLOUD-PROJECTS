# GSA ZTNA — Business Requirements, Design Decisions and Threat Model

## Business problem
A hybrid organisation exposes internal applications to users who may have network reachability without a valid business need. Traditional VPN or VNet peering can grant broad network paths, while identity-aware application controls only govern traffic that traverses their enforcement point.

## Business requirements
- Publish selected private applications without exposing inbound connector ports to the public Internet.
- Authenticate users with Microsoft Entra ID and require explicit application assignment.
- Demonstrate both an authorised path and a denied path using separate test identities.
- Keep the legacy endpoint's required AD management path while preventing its direct web-application path.
- Resolve private application names through the intended private DNS path.
- Collect enough sign-in, connector and endpoint evidence to explain allow/deny decisions.

## Success criteria
CLIENT02 reaches only its assigned private applications through GSA; CLIENT03 authenticates but is denied by assignment; CLIENT01 cannot bypass GSA to reach APP01; private DNS resolves to the lab private address; disconnecting the GSA client removes CLIENT02's private application path. The source validation matrix records these outcomes; capture fresh evidence before claiming a repeatable current result.

## Architecture and trust boundaries
- Identity plane: Microsoft Entra ID, Enterprise Application assignment and Conditional Access.
- Endpoint plane: GSA client and endpoint join state.
- Service edge: Global Secure Access / Entra Private Access.
- Connector boundary: outbound-initiated Private Network Connector group.
- Private workload plane: DC01 (AD DS/DNS) and APP01 (IIS portals).
- Network enforcement: VNet routes, NIC/subnet NSGs and host firewalls.

The lab uses DC01 (172.16.0.5), APP01 (172.16.0.10), CONN01 and three distinct endpoint/identity states. See [solution architecture](architecture.md).

## Security design decisions
| Decision | Rationale | Trade-off / residual risk |
|---|---|---|
| Publish individual application segments | Limits exposure to named destinations and ports rather than a broad subnet | AD/RSAT requires multiple protocols and dynamic RPC; the lab range is broad |
| Require Enterprise Application assignment | Separates authentication from per-application authorisation | Stale group assignments and token/session state can affect test interpretation |
| Use separate positive and negative identities | Makes allow/deny outcomes attributable | Requires identity lifecycle and test-session hygiene |
| Isolate CLIENT02/03 from direct VNet routes | Makes GSA the intended private access path | Network changes must be checked for alternate routes and peering |
| Use one connector in the lab | Keeps the lab small and affordable | Single point of failure; not production HA |

## Threat model
| Threat | Attack path / impact | Lab control | Residual risk / next test |
|---|---|---|---|
| Unassigned user accesses a private app | Authenticated user attempts an app without entitlement | Assignment required; explicit user/group assignment | Test direct and transitive group membership, stale sessions and token refresh |
| Network-path bypass | Endpoint uses peering/VPN/direct route around GSA | NIC-scoped NSG on CLIENT01; isolated CLIENT02/03 | Review effective routes, subnet NSGs, host firewall and alternate VPN paths |
| Compromised connector | Connector host becomes a pivot into private network | Outbound-only connector model; narrow app segments | Harden/patch connector, least privilege, EDR, monitor health; deploy redundant connectors |
| DNS manipulation or fallback | Private name resolves publicly or to attacker-controlled address | Private DNS/NRPT path and resolver validation | Test resolver order, NRPT, split-brain DNS and DNS outage behaviour |
| Over-broad AD/RPC exposure | Large dynamic RPC range increases reachable service surface | Destination restricted to DC01 | Constrain RPC range where supported; limit connector and firewall scope |
| Conditional Access misconfiguration | Enrollment or emergency access is unintentionally blocked | Application-targeted CA and documented exceptions | Test enrollment, break-glass, compliant-device and risk policies separately |
| Credential or tenant leakage | Screenshots/scripts expose UPNs, tenant IDs or tokens | Sanitised examples and runtime secret handling | Scan repository history and evidence before publication |

## Architecture decision records
- **ADR-01 — Per-application publication:** use individual application segments instead of publishing the whole server subnet.
- **ADR-02 — Explicit assignment:** require assignment on each Private Access Enterprise Application; do not treat network reachability as authorisation.
- **ADR-03 — Separate test identities:** use distinct authorised and unassigned identities to avoid ambiguous test results.
- **ADR-04 — Alternate-path denial:** use network controls to ensure legacy routes do not bypass the identity-aware enforcement point.
- **ADR-05 — Lab availability boundary:** one connector is acceptable for a lab demonstration only; production requires at least two connectors per connector group and tested failover.

## Production acceptance gates
Before production use, require connector redundancy, HTTPS for application portals, compliant-device policy where appropriate, phishing-resistant MFA for administrators, access reviews, logging/alerting, tested rollback, and a documented RPC/network exposure review.
