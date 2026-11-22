# GSA ZTNA — Troubleshooting and Diagnostic Register

The following issues are based on the source capstone's ten-blocker record. The descriptions preserve the observed cause and resolution while omitting tenant-specific identifiers, request IDs and correlation IDs.

| ID | Symptom | Root cause / resolution |
|---|---|---|
| B-01 | Hybrid Entra-joined devices failed Intune MDM auto-enrolment | Tenant-wide MFA Conditional Access scope affected enrollment; the Microsoft Intune Enrollment service principal was absent. Restored/created the service principal and reviewed enrollment endpoint exclusions. |
| B-02 | Uncertainty over User vs Device Credential in MDM auto-enrollment GPO | Tested the policy on a disposable VM and confirmed User Credential for this environment's GPO path. |
| B-03 | GSA client rollout through Intune took additional troubleshooting | Win32 packaging, install/uninstall commands, detection rule, assignment timing and device enrollment state all had to align. Client was successfully packaged and deployed; pilot validation recommended. |
| B-04 | ADUC intermittently hung after connection | TCP 135 endpoint mapper succeeded, but negotiated dynamic RPC ports were omitted. Adding TCP 49152–65535 resolved the observed test. |
| B-05 | AADSTS50105 despite explicit user assignment | A stale/default group assignment remained on the enterprise application. Audited service-principal assignments with Microsoft Graph and removed the unintended assignment. |
| B-06 | CLIENT01 accessed apps without GSA assignment | Direct VNet peering provided a network path that bypassed GSA. Applied a NIC-scoped NSG to constrain CLIENT01's direct path. |
| B-07 | CLIENT02 had no GSA virtual adapter/tunnel | Device identity was bound to a different Entra tenant; the Azure AD Login for Windows VM extension reasserted the wrong tenant join. Removed the extension, left the stale join, rebooted, rejoined to the lab tenant and verified with dsregcmd. |
| B-08 | Private FQDN resolved through public DNS to an invalid address | GSA private DNS/NRPT path was not active as intended. Verified GSA adapter, NRPT, connector and authoritative DNS record; corrected client scope/configuration and confirmed internal resolution. |
| B-09 | Entra account failed Windows VM RDP sign-in | Entra VM authentication requires the VM login extension and appropriate Virtual Machine User Login / Administrator Login RBAC. Lab continued with local admin RDP; this was not treated as proof of Entra-based RDP. |
| B-10 | Same identity produced contradictory allow/deny tests | One identity was being used for mutually exclusive authorization states. Reworked to dedicated jdean, labadmin and testdeny identities/endpoints. |

## Diagnostic commands captured in the source

### Entra device join and tenant identity
~~~cmd
dsregcmd /status
dsregcmd /leave
~~~

### RPC path
~~~powershell
Test-NetConnection 172.16.0.5 -Port 135
Test-NetConnection 172.16.0.5 -Port 49668
~~~

### Private DNS and endpoint state
~~~powershell
Get-DnsClientServerAddress
Get-DnsClientNrptPolicy
Test-NetConnection 172.16.0.5 -Port 53
Resolve-DnsName admin.labcorp.local -Server 172.16.0.5
Resolve-DnsName admin.labcorp.local
Test-NetConnection 172.16.0.10 -Port 80
~~~

### Audit enterprise application assignments
~~~powershell
Connect-MgGraph -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All"
$spId = "<enterprise-application-service-principal-object-id>"
Get-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $spId |
  Select-Object PrincipalDisplayName, PrincipalType, AppRoleId
~~~

Only remove an assignment after confirming the exact principal and business owner. The placeholder is intentional; no tenant-specific object ID is published.

## Key engineering lessons
1. Diagnose the complete protocol path, not only the well-known port. RPC endpoint mapper success does not prove the negotiated RPC data channel is allowed.
2. Separate DNS resolution from TCP reachability; validate the GSA adapter, NRPT, connector route and authoritative record independently.
3. Confirm tenant binding and identity-related VM extensions before repeatedly attempting in-guest re-joins.
4. Audit enterprise application assignments, including inherited group membership and stale assignments, before interpreting AADSTS50105.
5. Build dedicated positive and negative test identities from the beginning.
6. Test for alternate routes around the enforcement point. A Private Access policy cannot govern traffic that bypasses the GSA data plane.
