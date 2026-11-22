# Troubleshooting record and engineering lessons

The source project documented ten blockers. This summary retains their engineering lessons while removing tenant-specific identifiers and request metadata.

| ID | Symptom | Root cause / resolution | Reusable lesson |
|---|---|---|---|
| B-01 | Conditional Access MFA policy interfered with Intune MDM auto-enrolment. | The enrollment service flow was affected by tenant CA policy; the dependency and required narrow policy adjustment were identified. | Test enrollment separately; document and periodically review narrowly scoped service-principal exclusions. |
| B-02 | Hybrid-join / MDM GPO setup was ambiguous. | User-credential versus device-credential selection changed enrollment behaviour. | Document the intended credential mode and validate with device registration and MDM diagnostics. |
| B-03 | Intune-managed GSA client packaging/deployment exceeded the project timeline. | Packaging, detection and assignment dependencies added overhead. | Use a controlled pilot and documented deployment method; do not skip deployment validation. |
| B-04 | ADUC/RSAT connections were intermittent or timed out over Private Access. | TCP 135 was configured but the dynamic RPC range was omitted. Adding the Windows dynamic RPC range resolved the missing transport path in the lab. | AD management is multi-port. Model dependencies completely; constrain ranges where possible rather than opening broadly without review. |
| B-05 | An assigned user still received AADSTS50105. | Stray/default group assignments and effective assignment state made results inconsistent. The assignment list was audited and unintended groups removed. | Verify effective assignments and group membership, not just the intended direct assignment. |
| B-06 | CLIENT01 reached applications it was not assigned to in GSA. | CLIENT01 had a direct VNet route to the backend, bypassing GSA. A NIC-scoped NSG denied its APP01 path while preserving the intended DC01 path. | Identity-plane controls cannot govern traffic that does not traverse the identity-aware data plane. Control alternate routes. |
| B-07 | CLIENT02 device identity registered to the wrong Entra tenant. | Imported VM/subscription directory association and an existing identity-related VM extension conflicted with intended tenant registration. | Add tenant alignment and VM-extension checks to imported-VM onboarding. |
| B-08 | Private hostnames resolved through public DNS instead of GSA private DNS. | The client used public resolvers and did not initially apply the intended private suffix routing. The GSA DNS path was corrected and validated against DC01. | Validate the actual resolver path and returned record, not just DNS server reachability. |
| B-09 | Entra ID sign-in to an Azure VM over RDP failed. | Entra-based VM sign-in requires the relevant VM login extension and Azure RBAC VM login role, in addition to correct client-side RDP configuration. | Separate Windows local/domain authentication from Entra VM login prerequisites and RBAC. |
| B-10 | Reusing one identity for allow and deny tests produced contradictory results. | The test design conflated positive and negative authorisation. Dedicated authorised and unassigned identities/devices were created. | Use positive and negative controls; document session/token state and effective assignments. |

## Diagnostic commands

~~~powershell
# Device registration and tenant context
dsregcmd /status

# Private DNS and resolver path
nslookup finance.labcorp.local
Resolve-DnsName finance.labcorp.local
Get-DnsClientServerAddress

# Backend connectivity
Test-NetConnection 172.16.0.5 -Port 389
Test-NetConnection 172.16.0.10 -Port 80

# RSAT capability
Get-WindowsCapability -Online -Name "Rsat.ActiveDirectory*"
~~~

~~~bash
# VM extension diagnostics
az vm extension list --resource-group <resource-group> --vm-name <vm-name> -o table

# NSG configuration and effective rules
az network nsg show --resource-group <resource-group> --name <nsg-name> -o json
az network nic show-effective-nsg --resource-group <resource-group> --name <nic-name>
~~~

## Evidence discipline
For every incident record timestamp, affected resource, expected behaviour, observed output, hypothesis, diagnostic evidence, root cause, corrective action, retest result and residual risk. Do not publish raw request IDs, correlation IDs, tenant IDs, UPNs or secrets.
