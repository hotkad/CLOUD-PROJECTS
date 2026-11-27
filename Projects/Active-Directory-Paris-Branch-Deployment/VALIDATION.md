# Validation and Evidence Log

Use this file as a checklist during the lab. Tick an item only after observing the state in the environment. Attach sanitized screenshots under `evidence/` and reference their filenames in the notes. Remove hostnames, public IPs, usernames, tenant IDs, secrets, and other sensitive information before publishing.

## Task 1 — Site and domain controller

- [ ] Paris site exists in Active Directory Sites and Services.
- [ ] Subnet `172.16.1.0/24` is associated with Paris.
- [ ] DC2 is a writable domain controller for `contoso.com`.
- [ ] DC2 appears under Paris → Servers.
- [ ] DC2 appears in the Domain Controllers OU.
- [ ] Replication between DC1 and DC2 is healthy.
- [ ] RID Operations Master is DC2 (verify in ADUC → domain Properties/Operations Masters → RID).
- Evidence files:
- Notes / observed errors:

## Task 2 — Paris objects and delegation

- [ ] Paris OU exists directly under the domain.
- [ ] ParisContractor is in Paris OU.
- [ ] Account expiration is December 31, 2027.
- [ ] **Account is sensitive and cannot be delegated** is selected on ParisContractor.
- [ ] Paris Admins is a Universal Security group.
- [ ] ParisContractor is a member of Paris Admins.
- [ ] Paris Admins has the requested password-reset delegation on Paris OU scope only.
- [ ] No unrelated privileged group membership or broad delegation was added.
- Evidence files:
- Notes / observed errors:

## Task 3 — Users with City = Paris

- [ ] Search criteria was User → City → Is → Paris.
- [ ] All matching user accounts were identified (record count: ______).
- [ ] Matching users were moved to Paris OU.
- [ ] Each moved account is disabled.
- [ ] Each moved account has User must change password at next logon selected.
- Evidence files:
- Notes / observed errors:

## Task 4 — Password policy and Recycle Bin

- [ ] Default Domain Policy minimum password length = 12.
- [ ] Fine-grained policy exists and has minimum length = 16.
- [ ] FGPP directly applies to Domain Admins.
- [ ] FGPP precedence and resultant policy were reviewed.
- [ ] Active Directory Recycle Bin enabled.
- [ ] Deleted Objects container visible after replication.
- Evidence files:
- Notes / observed errors:

## Task 5 — Group Policy

- [ ] Default Domain Controllers Policy contains the exact policy **Network security: Restrict NTLM: NTLM authentication in this domain**.
- [ ] The selected value is the deny-all mode required by the task (record exact UI label: ______).
- [ ] GPO1 exists.
- [ ] GPO1 is linked to Paris OU only and Link Enabled = Yes.
- [ ] Audit Logon: Failure enabled; Success not enabled by this setting.
- [ ] Deny log on as a service includes Paris Admins.
- [ ] Existing user-rights assignment entries were preserved.
- [ ] Paris computer objects are in GPO1's scope if computer-side settings are expected to process.
- Evidence files:
- Notes / observed errors:

## Evidence register

| Date | Requirement | Screenshot / artifact | Result | Notes |
|---|---|---|---|---|
| YYYY-MM-DD | Example: Paris site and subnet | `evidence/paris-site.png` | Pending | Sanitize before commit |

## Completion statement

Do not mark the project fully complete until every applicable item has been observed and supporting evidence has been captured. A written runbook is not proof of successful implementation. Record any uncompleted requirement or environment limitation honestly.
