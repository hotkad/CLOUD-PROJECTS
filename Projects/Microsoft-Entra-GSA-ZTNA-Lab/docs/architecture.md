# Solution architecture

## Architecture intent
The lab demonstrates Zero Trust Network Access for private applications using Microsoft Entra Private Access as part of Global Secure Access. It separates network reachability from identity authorisation and intentionally creates three client postures to test permitted and denied paths.

## Components

| Component | Function | Security responsibility |
|---|---|---|
| Microsoft Entra ID | Cloud identity and authentication | User identity, app assignment, sign-in context |
| Global Secure Access client | Endpoint traffic steering | Captures supported private traffic and sends it to GSA |
| Entra Private Access | Private application access service | Brokers access to published private resources |
| Private Network Connector | Cloud-to-private-network connector | Outbound-initiated connectivity; no inbound connector listener required |
| Connector group | Logical connector grouping | Maps application segments to connector capacity |
| Enterprise Applications | Published application objects | Explicit assignment and Conditional Access targeting |
| DC01 | AD DS, DNS, Entra Connect | Hybrid identity source, private DNS and AD management target |
| APP01 | IIS multi-site server | Hosts Finance, HR and Operations test portals |
| CLIENT01 | Domain/hybrid-joined endpoint | Legacy network trust baseline |
| CLIENT02 | Entra-joined authorised endpoint | Positive Zero Trust access test |
| CLIENT03 | Entra-joined unassigned endpoint | Negative authorisation test |

## Addressing and naming

| Name | Value |
|---|---|
| AD DNS domain | labcorp.local |
| DC01 | 172.16.0.5 |
| APP01 | 172.16.0.10 |
| Private DNS suffix | labcorp.local |
| Portal hostnames | finance.labcorp.local, hr.labcorp.local, admin.labcorp.local |

Tenant-specific identifiers and cloud UPN suffixes are intentionally omitted.

## Traffic and trust flows

### Authorised client (CLIENT02)
1. User authenticates to the Entra-joined endpoint.
2. GSA client establishes service connectivity and captures traffic matching the Private Access profile.
3. User requests a published private FQDN/application.
4. GSA/Private Access brokers the request through the assigned connector group.
5. Connector reaches the internal destination over the private network.
6. Entra application assignment and applicable Conditional Access determine whether the identity is authorised.
7. Private DNS resolves the private namespace through the configured GSA DNS path.

### Unassigned client (CLIENT03)
CLIENT03 follows the same isolated network and GSA route as CLIENT02 but uses an identity excluded from application assignments. Authentication can succeed while application authorisation is denied. The lab recorded AADSTS50105 when Assignment required was enabled and no direct or group assignment existed.

### Legacy endpoint (CLIENT01)
CLIENT01 is domain joined and has network-level reachability to the private subnet. Traffic sent directly over the VNet route does not pass through the GSA data plane and cannot be assumed to receive GSA assignment enforcement. A NIC-scoped NSG denied CLIENT01's APP01 path while preserving the intended DC01 connectivity.

## AD / RSAT port model

| Port | Protocol | Purpose |
|---:|---|---|
| 53 | TCP/UDP | DNS |
| 88 | TCP/UDP | Kerberos |
| 135 | TCP | RPC Endpoint Mapper |
| 389 | TCP/UDP | LDAP |
| 445 | TCP | SMB |
| 464 | TCP/UDP | Kerberos password operations |
| 636 | TCP | LDAPS |
| 3268 | TCP | Global Catalog |
| 3269 | TCP | Global Catalog over SSL |
| 49152–65535 | TCP | Windows dynamic RPC range used in this lab |

Allowing TCP 135 alone was insufficient for reliable ADUC/RSAT operations because the endpoint mapper directs clients to a dynamic RPC port. Validate the actual port requirements and consider narrowing the server-side dynamic range where supported.

## Application segmentation
APP01 hosted three IIS sites using host headers. Each portal was published as a separate Private Access application segment using APP01's private IP and required web port. Separate definitions preserve per-application access governance rather than publishing a broad subnet.

## Security boundaries and assumptions
- Connector-to-cloud connectivity is outbound initiated.
- Connector-to-application connectivity is internal and should be constrained to required resources and ports.
- Private Access segments do not replace host firewalls, NSGs, application authentication, or device compliance.
- A published application is not protected from alternate paths unless those paths are explicitly controlled.
- The lab used one connector; production requires redundancy and monitoring.
