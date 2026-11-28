# Evidence register

No screenshots or validation exports are currently committed here. Capture the state from the lab after each task and mark the corresponding item in VALIDATION.md only when observed.

## Evidence to capture
| ID | Evidence | Redaction / validation |
|---|---|---|
| AD-01 | Paris site and 172.16.1.0/24 subnet | Hide production domain identifiers if any |
| AD-02 | DC2 promotion and Paris site placement | Show writable DC / Global Catalog status as applicable |
| AD-03 | Replication health and RID Master holder | Include timestamp and role holder |
| AD-04 | Paris OU, ParisContractor and Paris Admins | Redact usernames if not synthetic |
| AD-05 | Delegation wizard / effective OU ACL | Verify password-reset task and OU scope |
| AD-06 | City=Paris search and moved-account state | Redact real user details |
| AD-07 | Domain password policy and FGPP | Show 12 and 16 character settings and FGPP target |
| AD-08 | Recycle Bin enabled | Show Deleted Objects container |
| AD-09 | Exact NTLM restriction policy value | Capture full policy name and selected option |
| AD-10 | GPO1 link, Audit Logon failure and Deny log on as a service | Verify GPO scope and preserve existing entries |

Use synthetic accounts wherever possible. Never publish DSRM passwords, user passwords, real domain names, production user lists or privileged account identifiers.
