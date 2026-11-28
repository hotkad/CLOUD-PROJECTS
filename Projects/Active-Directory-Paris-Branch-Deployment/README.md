# Active Directory Branch Office Deployment — Paris

A GUI-based Active Directory Domain Services (AD DS) administration lab covering the deployment of a second domain controller in a new branch site, delegated administration, user lifecycle operations, password policy, object recovery, and Group Policy hardening.

> **Project record status:** Documentation of the supplied assessment requirements and GUI implementation procedure. Individual completion claims must be backed by screenshots or validation output in the `evidence/` directory. Do not treat a checked procedure as proof that a change was successfully applied.

## Scenario

The fictional `contoso.com` organization is opening a Paris office. The task is to extend its existing AD DS environment while limiting administrative changes to those required by the project brief.

### Target design

| Component | Target configuration |
|---|---|
| Existing domain | `contoso.com` |
| Existing domain controller | DC1 |
| Additional domain controller | DC2 |
| AD site | Paris |
| Paris subnet | `172.16.1.0/24` |
| DC2 site assignment | Paris |
| DSRM password | Supplied assessment value; never publish credentials in this repository |
| RID Operations Master | DC2 after successful replication and transfer |
| Paris OU | `OU=Paris,DC=contoso,DC=com` |
| Contractor account | `ParisContractor` |
| Paris administrative group | `Paris Admins` — Universal, Security |
| Contractor expiry | 31 December 2027 |
| Domain minimum password length | 12 characters |
| Domain Admins FGPP minimum length | 16 characters |
| Recovery | Active Directory Recycle Bin enabled |
| GPO 1 | Default Domain Controllers Policy: required domain NTLM restriction |
| GPO 2 | GPO1 linked to Paris OU: failed logon auditing and deny service logon for Paris Admins |

## Objectives and implementation scope

1. Create the Paris AD site and associate `172.16.1.0/24`.
2. Install AD DS on DC2, promote it as an additional writable domain controller for `contoso.com`, and assign it to Paris.
3. After replication is healthy, transfer only the RID Operations Master role to DC2.
4. Create the Paris OU, contractor user, and universal security group.
5. Add the contractor to the built-in Protected Users group and configure the account expiry.
6. Delegate password-reset management to Paris Admins at the Paris OU scope only.
7. Find user accounts whose City attribute equals Paris, move them into the Paris OU, disable them, and set the next-logon password-change flag.
8. Set the domain minimum password length to 12 and create a fine-grained password policy for Domain Admins with a minimum length of 16.
9. Enable the AD Recycle Bin.
10. Configure the requested NTLM restriction and create GPO1 for Paris OU.

## GUI tools

- Active Directory Sites and Services
- Server Manager — Add Roles and Features / AD DS Configuration Wizard
- Active Directory Users and Computers (ADUC)
- Active Directory Administrative Center (ADAC)
- Group Policy Management Console (GPMC)
- Group Policy Management Editor

This project is intentionally documented as a GUI workflow. PowerShell may be useful for independent validation, but it is not the implementation method described here.

## Security and operational considerations

- **Credentials:** The DSRM password and any account bootstrap password are intentionally excluded from source control. Never commit passwords, recovery keys, secrets, or production identifiers.
- **Protected Users:** Membership in the Protected Users group enforces additional authentication restrictions. Confirm the account's required authentication methods and application compatibility before using it operationally.
- **Delegation:** Paris Admins should receive only the password-reset delegation required by the task. Do not add the group to Domain Admins, Account Operators, or other privileged groups.
- **FGPP:** Fine-grained password policies apply to users and global security groups, not OUs or universal groups. Domain Admins is the intended target.
- **Disabled accounts:** A disabled user cannot log on to perform the forced password change. The two requested account flags are separate and should both be verified.
- **Recycle Bin:** Enabling the AD Recycle Bin is a forest-wide, irreversible enablement. Confirm prerequisites and obtain the appropriate approval before enabling it.
- **NTLM:** A deny-all NTLM policy can disrupt legacy applications and services. Confirm the exact policy name and option in the target Windows Server version before enforcement; audit dependencies and assess impact in production.
- **GPO scope:** GPO1 is linked to the Paris OU. Computer-side settings apply to computer accounts in the OU (or descendant OUs), not simply to users who belong to Paris Admins. Confirm the intended Paris computers are within scope.
- **User-rights assignment:** When adding Paris Admins to *Deny log on as a service*, preserve existing entries unless the assessment explicitly requires otherwise.

## Repository layout

- [GUI implementation guide](IMPLEMENTATION-GUIDE.md) — ordered click-by-click workflow.
- [Validation and evidence checklist](VALIDATION.md) — expected results and evidence to capture.
- [Evidence directory](evidence/) — add sanitized screenshots and exported validation records. No evidence is included until it is captured and reviewed.

## Completion and evidence standard

For each requirement, record:
- Date and environment (lab only; do not publish sensitive tenant or domain details).
- GUI location and setting changed.
- Expected result.
- Actual result and validation method.
- Screenshot filename or other sanitized evidence reference.
- Any warning, failure, remediation, or outstanding limitation.

A procedure being documented does not mean the task was completed. Mark a requirement **Verified** only after observing the expected state in the lab.

## References

- [Install Active Directory Domain Services](https://learn.microsoft.com/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
- [Active Directory Sites and Services](https://learn.microsoft.com/windows-server/identity/ad-ds/plan/active-directory-site-topology)
- [Transfer or seize FSMO roles](https://learn.microsoft.com/troubleshoot/windows-server/active-directory/fsmo-roles)
- [Fine-grained password policies](https://learn.microsoft.com/windows-server/identity/ad-ds/get-started/adac/fine-grained-password-policies)
- [Active Directory Recycle Bin](https://learn.microsoft.com/windows-server/identity/ad-ds/get-started/adac/active-directory-recycle-bin)
- [Restrict NTLM authentication](https://learn.microsoft.com/windows/security/threat-protection/security-policy-settings/network-security-restrict-ntlm-ntlm-authentication-in-this-domain)
- [Audit Logon](https://learn.microsoft.com/windows/security/threat-protection/auditing/basic-audit-logon-events)

## Design, threat model and evidence
- [Business requirements, architecture, design decisions and threat model](docs/design-and-risk-analysis.md)
- [Evidence register](evidence/README.md)

**Correction:** the requested contractor protection setting is documented as **Account is sensitive and cannot be delegated**. This is distinct from membership in the Protected Users group. Follow the implementation guide and validate the exact requested account flag.
