# Deployment runbook

This sequence reconstructs the lab build from the project record. It is not a turnkey production deployment. Verify current Microsoft prerequisites, supported operating systems, licensing, service endpoints and portal labels before use.

## Phase 0 — Planning
1. Use a dedicated Azure subscription and Entra tenant.
2. Define resource group, region, VNet, subnets, NSGs and IP ranges.
3. Confirm Entra ID P1/P2 and relevant Global Secure Access / Private Access licensing.
4. Create separate authorised and negative-control identities.
5. Provision DC01, CONN01, APP01 and three Windows client VMs.
6. Confirm CONN01 has outbound TCP 443 connectivity to current Microsoft service endpoints and internal reachability to the applications.
7. Define the private DNS namespace and expected forwarding path.

## Phase 1 — Identity foundation (DC01)
1. Install AD DS and DNS.
2. Promote DC01 into the labcorp.local forest.
3. Create OUs for users, groups, servers and workstations.
4. Create dedicated test identities and security groups.
5. Install and configure Microsoft Entra Connect using the intended sync method.
6. Verify synchronisation and expected user objects in Entra ID.

Example forest promotion for a disposable lab only:

~~~powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "labcorp.local" -DomainNetbiosName "LABCORP" -InstallDNS -Force
~~~

See scripts/01-identity-foundation.ps1 for an example OU and test-user scaffold. Passwords are prompted at runtime; do not embed secrets in source control.

## Phase 2 — Private Network Connector (CONN01)
1. Install a supported, patched Windows Server version.
2. Validate DNS and outbound TCP 443 connectivity to the current Microsoft Entra Private Access endpoints.
3. Download the connector from the Global Secure Access admin center.
4. Install and register using an appropriately privileged, controlled account.
5. Place the connector in a dedicated connector group.
6. Verify connector health and reachability to DC01 and APP01.
7. Do not expose inbound Internet ports to the connector unless current Microsoft documentation explicitly requires them.

Production note: deploy at least two connectors per connector group across failure domains.

## Phase 3 — Application host (APP01)
1. Install IIS and management tools.
2. Create the three portal content roots.
3. Configure Finance, HR and Operations host-header sites.
4. Use separate application pools.
5. Validate local site bindings and HTTP responses before adding GSA.

Run scripts/02-deploy-iis-portals.ps1 in an elevated PowerShell session on APP01.

## Phase 4 — Private DNS
1. Confirm the labcorp.local DNS zone exists on DC01.
2. Create A records for finance, hr and admin hostnames pointing to APP01.
3. Enable Private DNS for the relevant Private Access application configuration.
4. Configure labcorp.local as the private suffix and associate the intended connector group/DNS path.
5. Validate the actual resolver and returned private address from CLIENT02.

See scripts/03-private-dns-records.ps1.

## Phase 5 — Private Access application segments
Create narrowly scoped application definitions for:
- AD/RSAT management traffic to DC01, including required service ports and the Windows dynamic RPC range where applicable.
- Each IIS portal on APP01 as a separate application segment.

See config/application-segments.csv. Avoid publishing an entire subnet when per-application segmentation is practical.

## Phase 6 — Endpoint posture
- CLIENT01: domain/hybrid joined and peered to the server network for the legacy baseline. Apply scripts/04-client01-isolation.azcli to deny its direct APP01 path while preserving the intended DC01 test path.
- CLIENT02: Entra joined, isolated from the application VNet, GSA client installed, authorised test identity assigned.
- CLIENT03: same isolated posture as CLIENT02, but the negative-control identity remains unassigned.

Validate tenant registration with dsregcmd /status before testing.

## Phase 7 — GSA and Conditional Access
1. Enable the Private Access traffic forwarding profile.
2. Scope it to the intended pilot users/devices.
3. Associate each application with the intended connector group.
4. Set Assignment required = Yes on each Enterprise Application.
5. Assign the authorised test identity/group only.
6. Leave the negative-control identity unassigned.
7. Enable Conditional Access signalling for Microsoft Entra ID in the current GSA session/adaptive access settings.
8. Configure application-specific Conditional Access policies, carefully accounting for enrollment dependencies and emergency access.
9. Test authentication, application assignment and network reachability independently.

The source lab also explored Internet Access security profiles/content filtering as a secondary control plane; this was not the core Private Access proof.

## Phase 8 — Evidence and validation
Use docs/validation-matrix.md. Capture connector health, app segment configuration, effective assignments, CA policy state, sign-in results, DNS resolver output, device join state, effective NSG rules and positive/negative access tests. Sanitise tenant IDs, UPNs, request IDs, correlation IDs, subscription IDs and public IPs before publication.
