# Evidence register

No screenshots or raw tenant exports are currently committed in this directory. Add evidence only after capturing it from the actual lab. Do not create illustrative screenshots and present them as deployment proof.

## Evidence to capture
| ID | Evidence | Redaction / validation |
|---|---|---|
| GSA-01 | Connector group and connector health | Hide tenant identifiers and connector host details not needed for the demonstration |
| GSA-02 | Private Access application segments and port scopes | Hide tenant IDs and unrelated applications |
| GSA-03 | Assignment-required setting and authorised assignment | Redact UPNs; retain role/group relationship |
| GSA-04 | CLIENT02 successful application access | Redact user, device and tenant identifiers |
| GSA-05 | CLIENT03 AADSTS50105 denial | Redact request/correlation IDs, UPN and application IDs |
| GSA-06 | Private DNS resolution and resolver/NRPT evidence | Use lab RFC1918 addresses only |
| GSA-07 | CLIENT01 effective NSG and denied APP01 test | Remove subscription/resource IDs |
| GSA-08 | GSA disconnect negative test | Redact endpoint identifiers |

## Naming convention
Use `GSA-01-connector-health.png`, `GSA-02-app-segments.png`, etc. Record capture date, test identity alias, expected result, observed result and any caveat in a separate evidence log.

## Publication controls
Never commit tenant IDs, subscription IDs, real UPNs, public IPs, request/correlation IDs, access tokens, certificates, customer names, or raw diagnostic bundles. Review screenshots at full resolution before committing.
