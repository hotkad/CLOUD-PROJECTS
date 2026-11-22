# GSA ZTNA Capstone — Architecture and Build Record

This document expands the existing portfolio project using the 75-page Infinion Technologies capstone report. It records the implemented lab design and its observed validation results. It is a sanitised engineering summary, not a copy of the employer-branded source report.

## 1. Executive objective

Demonstrate identity-centric, per-application access to private enterprise resources using Microsoft Entra Private Access and Global Secure Access (GSA), replacing implicit trust based on network location. The lab contrasts a hybrid/domain-joined workstation with Entra-joined endpoints that rely on the GSA tunnel.

## 2. Logical architecture

| Component | Role | Address / identity |
|---|---|---|
| DC01 | AD DS, DNS, Entra Connect, ADUC target | 172.16.0.5 |
| CONN01 | Microsoft Entra Private Network Connector | Connector group: Project Connector – Europe |
| APP01 | IIS-hosted Finance, HR and Operations portals | 172.16.0.10 |
| CLIENT01 | Hybrid/domain-joined baseline workstation | User: jdean |
| CLIENT02 | Entra-joined authorised Zero Trust endpoint | User: labadmin |
| CLIENT03 | Entra-joined negative-control endpoint | User: testdeny |

The environment uses the fictional LabCorp namespace `labcorp.local` and private RFC1918 addressing. Values are lab-only and must not be treated as production configuration.

## 3. Design model

Three distinct endpoint/identity states were deliberately created:

- **CLIENT01 / jdean:** domain-joined and network-peered. It represents legacy network trust. A NIC-scoped NSG limits it to the AD/DC path while blocking APP01 web access.
- **CLIENT02 / labadmin:** Entra-joined on an isolated subnet with no direct peering to the application network. Its approved access path is GSA Private Access.
- **CLIENT03 / testdeny:** Entra-joined negative control, intentionally not assigned to the Private Access applications. This proves the difference between successful authentication and application authorisation.

This test design avoids using one identity for contradictory allow and deny scenarios.

## 4. Identity foundation

DC01 hosts the `labcorp.local` AD DS forest, DNS and Microsoft Entra Connect. The build created organisational units, groups and a synced on-premises test identity. A cloud-only `testdeny` identity was created directly in Entra ID so its negative access result was independent of on-premises attributes or GPO state.

Before evaluating application access, the lab verified Entra Connect sync status and scheduler state using:

~~~powershell
Get-ADSyncConnectorRunStatus
Get-ADSyncScheduler
~~~

## 5. Private Network Connector

CONN01 was installed on the same peered subnet as DC01/APP01 and registered to the Entra tenant. It was assigned to the dedicated connector group **Project Connector – Europe**. The connector showed Active status and established an outbound-only control channel; no inbound firewall rule was required on the connector host.

A single connector was used in this lab. This is a single point of failure and is not an enterprise availability design.

## 6. Application publishing and private DNS

APP01 hosts three IIS sites using host headers:
- Finance: `finance.labcorp.local`
- HR: `hr.labcorp.local`
- Operations/Admin portal: `admin.labcorp.local` (the report uses both Ops/Admin naming in different sections)

Each portal was published as a separate Private Access application segment, scoped to APP01 and TCP 80. DC01 hosts private DNS A records pointing each portal name to 172.16.0.10. The `labcorp.local` suffix was configured for private DNS routing through the connector group.

Example DNS records:

~~~powershell
Add-DnsServerResourceRecordA -ZoneName "labcorp.local" -Name "finance" -IPv4Address "172.16.0.10"
Add-DnsServerResourceRecordA -ZoneName "labcorp.local" -Name "hr" -IPv4Address "172.16.0.10"
Add-DnsServerResourceRecordA -ZoneName "labcorp.local" -Name "admin" -IPv4Address "172.16.0.10"
~~~

## 7. Active Directory application segment

The ADUC/RSAT segment targets DC01 and requires the relevant AD, DNS, Kerberos, LDAP, SMB and RPC flows. The critical diagnostic discovery was that TCP 135 is only the RPC endpoint mapper; modern Windows RPC operations also negotiate dynamic TCP ports.

| Port(s) | Protocol | Purpose |
|---|---|---|
| 53 | TCP/UDP | DNS |
| 88 | TCP/UDP | Kerberos |
| 464 | TCP/UDP | Kerberos password change |
| 389 | TCP/UDP | LDAP |
| 636 | TCP/UDP | LDAPS |
| 3268, 3269 | TCP | Global Catalog |
| 445 | TCP | SMB |
| 135 | TCP | RPC endpoint mapper |
| 49152–65535 | TCP | Dynamic RPC range |

Port requirements must be validated against the target AD/Windows configuration and narrowed where feasible; broad dynamic RPC exposure has a meaningful security impact.

## 8. Conditional Access and assignment model

Enterprise application assignment is the primary user-level access control for the Private Access applications. The report records Assignment required = Yes.

| Enterprise application | Assigned identity | Deliberately unassigned |
|---|---|---|
| LabCorp Active Directory (ADUC) | jdean | testdeny, labadmin |
| LabCorp Portal – Finance | labadmin | testdeny, jdean |
| LabCorp Portal – HR | labadmin | testdeny, jdean |
| LabCorp Portal – Ops/Admin | labadmin | testdeny, jdean |

The report also records Conditional Access signalling enabled under Global Secure Access → Settings → Session Management → Adaptive Access. This allows Entra sign-in and Identity Protection signals to reflect whether a session is arriving through the GSA client.

**Architectural distinction:** Enterprise application assignment controls access to a named Private Access application. A GSA Internet Access Security Profile is a separate control plane for general internet traffic. These should not be conflated.

## 9. Client deployment

The GSA Windows client was packaged as an Intune Win32 application. The recorded deployment used:
- Install: PowerShell script invoking `GlobalSecureAccessClient.exe /quiet`
- Uninstall: `GlobalSecureAccessClient.exe /uninstall /quiet /norestart`
- Install context: System
- Return codes: 0 Success, 3010 Soft reboot, 1618 Retry
- Detection: client executable version under `C:\Program Files\Global Secure Access Client\TrayApp`
- Assignment: pilot group; restart grace period enabled

The source script also set the IPv4-preference registry value `DisabledComponents=0x20`, returning 3010 when that registry change required a restart. This setting is environment-specific and should not be copied into a production package without compatibility testing and change approval.

## 10. Network segmentation for the legacy endpoint

CLIENT01 had an alternate peered network path that could bypass GSA entirely. A dedicated NSG was attached to CLIENT01's NIC—not the shared subnet—to allow required DC01 AD ports while denying outbound access to APP01. Validation showed TCP 389 to DC01 succeeded and the APP01 web path failed as intended.

This demonstrates an important Zero Trust principle: identity-aware controls only govern traffic that traverses the enforcement path. A separate route to the backend can bypass application assignment.

## 11. Core validation outcomes

The source report records ten passing tests, including:
- Private DNS resolution of `admin.labcorp.local` through GSA.
- ADUC/OU browsing from CLIENT02 without RPC timeout.
- Access to all assigned web portal segments from CLIENT02.
- ADUC access from CLIENT01 through its legacy domain/network path.
- Denial of APP01 portal access from CLIENT01 by NSG.
- AADSTS50105 denial for unassigned CLIENT03 identity against ADUC and all three portals.
- CLIENT02 losing private application access when the GSA client is disconnected, because no alternate network path exists.
- GSA client network-location signal visible in sign-in logs.
- ADUC object-property editing completing after RPC dynamic port range was included.

See `validation-and-production-readiness.md` for the full test matrix and caveats.
