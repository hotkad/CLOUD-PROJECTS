# Validation and test matrix

The following matrix summarises the intended coverage and outcomes recorded in the lab documentation. Re-run tests in a fresh environment before treating results as current.

| Test | Source | Action | Expected / recorded outcome |
|---|---|---|---|
| T-01 | CLIENT02 | Resolve private portal FQDN | Private DNS returns APP01 private IP through GSA path |
| T-02 | CLIENT02 | Access assigned portal | Access succeeds through Private Access |
| T-03 | CLIENT03 | Access same portal while unassigned | Entra denies at assignment stage (AADSTS50105) |
| T-04 | CLIENT02 | Reach AD management endpoint | Required AD ports and RPC dynamic range permit intended traffic |
| T-05 | CLIENT01 | Test DC01 LDAP connectivity | TCP 389 succeeds in lab baseline |
| T-06 | CLIENT01 | Test APP01 web access | NIC-scoped NSG denies direct path |
| T-07 | CONN01 | Check connector health | Connector reports active/healthy in GSA admin center |
| T-08 | DC01 | Check Entra Connect sync | Sync status and expected user objects confirmed |
| T-09 | CLIENT02/03 | Check join state | Devices registered to intended Entra tenant |
| T-10 | CLIENT02 | Query private DNS | Resolver path is GSA/private DNS, not public fallback |

## Representative commands

~~~powershell
nslookup finance.labcorp.local
Resolve-DnsName finance.labcorp.local
Test-NetConnection 172.16.0.5 -Port 389
Test-NetConnection 172.16.0.10 -Port 80
dsregcmd /status
Get-DnsClientServerAddress
~~~

## Evidence to capture
- Connector status and connector group association.
- Private Access application segments and destination port definitions.
- Enterprise Application assignment configuration.
- Conditional Access policy state and target resources.
- CLIENT02 allowed-access result and CLIENT03 denial result.
- DNS lookup before/after correction, including resolver and returned IP.
- CLIENT01 effective NSG and connectivity tests.
- Entra Connect sync status.

## Interpretation caveats
- A successful TCP connection proves transport reachability, not user authorisation.
- Successful sign-in does not prove application assignment.
- AADSTS50105 proves the identity lacked effective assignment at evaluation time; it does not prove every other network path is blocked.
- A public DNS response for a private namespace indicates a DNS path issue, not necessarily a GSA service outage.
- Keep test identities, device state, session state and application assignment state separate.

## Source-document discrepancy
The source report includes one CLIENT01 test command referencing APP01 TCP 8081, while the IIS deployment and application segment sections specify TCP 80. This repository uses TCP 80 as the documented IIS configuration and flags the discrepancy rather than presenting 8081 as verified. Confirm the actual binding before reproducing that test.
