# Active Directory Paris Branch — Business Requirements, Architecture and Threat Model

## Business problem
A fictional organisation is extending its existing Active Directory domain to a Paris branch. It needs a second writable domain controller assigned to the correct AD site, scoped administration for Paris objects, stronger account/password controls, recoverability and targeted Group Policy settings.

## Business requirements
- Create the Paris AD site and associate subnet 172.16.1.0/24.
- Promote DC2 as an additional writable domain controller and transfer only the RID Operations Master after replication is healthy.
- Create a Paris OU, contractor account and Paris Admins universal security group.
- Delegate password-reset rights at the Paris OU only.
- Find users whose City attribute is Paris, move them to Paris OU, disable them and set the next-logon password-change flag.
- Configure the domain minimum password length and a fine-grained policy for Domain Admins.
- Enable AD Recycle Bin.
- Configure the required NTLM policy and GPO1 settings.

## Logical architecture
~~~mermaid
flowchart TB
  subgraph Forest["contoso.com forest"]
    DC1["DC1 — existing domain controller"]
    DC2["DC2 — Paris writable domain controller"]
    subgraph Sites["Active Directory Sites"]
      HQ["Existing site"]
      PAR["Paris site"]
      SUB["172.16.1.0/24"]
      PAR --- SUB
    end
    OU["OU=Paris"]
    GRP["Paris Admins — Universal Security"]
    USER["ParisContractor"]
    GPO["GPO1 — linked to Paris OU"]
    DC1 <-->|"AD replication"| DC2
    PAR --> DC2
    OU --> GRP
    OU --> USER
    OU --> GPO
  end
~~~

## Security design decisions
| Decision | Rationale | Trade-off / residual risk |
|---|---|---|
| Writable DC2 in Paris site | Provides local authentication and site-aware replication for branch workloads | Additional DC increases patching, backup and attack-surface requirements |
| Transfer only RID Master | Meets the task without unnecessary FSMO movement | Confirm replication and role-holder health before transfer |
| OU-scoped delegation | Limits Paris Admins to the required password-reset operation | Review effective inherited ACLs and prevent delegation creep |
| Universal security group | Matches the assessment's group-scope requirement | Validate cross-domain membership requirements; global groups are often simpler where possible |
| Fine-grained password policy for Domain Admins | Applies a stronger minimum length to privileged accounts | FGPP targets users/global security groups, not OUs or universal groups |
| Recycle Bin enabled | Improves recovery of deleted directory objects | Forest-wide and irreversible; backup remains necessary |
| GPO1 linked to Paris OU | Keeps the requested audit/user-rights settings scoped | Computer-side policy applies to computer accounts in scope, not merely users in the OU |

## Threat model
| Threat | Impact | Control / evidence | Residual risk / next test |
|---|---|---|---|
| DC2 compromise | Domain compromise or credential theft | Hardened server, restricted administration and replication health checks | Apply tiered administration, EDR, patching, secure backup and privileged access workstations |
| Excessive OU delegation | Privilege escalation through object modification | Delegate only password-reset task to Paris Admins at Paris OU | Inspect effective ACLs, inheritance and group membership |
| Password spraying / weak passwords | Account compromise | Domain minimum length and privileged FGPP | Add banned-password protection, MFA where applicable, smart lockout and monitoring |
| NTLM relay/downgrade | Credential interception or lateral movement | Required NTLM restriction policy | Audit legacy dependencies before enforcement; monitor NTLM usage |
| Malicious GPO modification | Persistent execution or privilege changes | GPO scope, restricted admin access and audit | Monitor GPO changes, delegate edit rights carefully and back up GPOs |
| Accidental object deletion | User/group/computer outage | AD Recycle Bin | Test restore workflow; maintain system-state backups |
| Service logon denial misconfiguration | Service outage | GPO1 adds Paris Admins to Deny log on as a service | Verify exact computer scope and preserve existing user-right assignments |
| Replication/site misconfiguration | Authentication delay or inconsistent directory state | Paris subnet/site association and replication validation | Monitor replication, DNS, time sync and site-link costs |

## Architecture decision records
- **ADR-01 — Site-aware branch placement:** map 172.16.1.0/24 to Paris before promoting DC2.
- **ADR-02 — Minimal FSMO change:** transfer only RID Master as required; do not seize or move unrelated roles.
- **ADR-03 — OU-scoped least privilege:** delegate password reset at Paris OU and avoid domain-wide administrative groups.
- **ADR-04 — FGPP target:** apply the privileged password settings to Domain Admins, not an OU or universal group.
- **ADR-05 — Irreversible recovery control:** enable Recycle Bin only after confirming forest prerequisites and approval.
- **ADR-06 — NTLM enforcement gate:** identify the exact deny option and audit legacy dependencies before production enforcement.

## Limitations
This is a single-domain branch lab. It does not demonstrate production multi-site replication design, redundant DNS, privileged access workstations, Windows LAPS, tiered administration, AD CS security, backup/restore testing or a complete disaster-recovery exercise.
