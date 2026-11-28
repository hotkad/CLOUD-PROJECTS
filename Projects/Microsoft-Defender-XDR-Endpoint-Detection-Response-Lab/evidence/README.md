# Evidence register

No screenshots, onboarding packages or raw forensic artifacts are currently committed here. Capture only sanitised screenshots from the lab. Never publish onboarding scripts/packages, raw incident exports, investigation packages, tokens or live IOC values.

## Evidence to capture
| ID | Evidence | Required validation |
|---|---|---|
| XDR-01 | Defender device inventory | Onboarded test device is reporting |
| XDR-02 | Device group configuration | Group1 scope and automation level |
| XDR-03 | ASR policy | Rule setting and intended Entra group assignment |
| XDR-04 | Incident overview and attack graph | Alerts, process chain and endpoint identity |
| XDR-05 | IOC configuration | Indicator type, action, severity, expiry and scope; redact value |
| XDR-06 | Custom detection | Query, schedule, entity mappings and response actions |
| XDR-07 | Live Response | Session and connection-inspection result |
| XDR-08 | Investigation package | Action completion metadata only; do not publish raw package |
| XDR-09 | Isolation | Device isolation state and action timestamp |

Record the actual endpoint name privately and resolve the Client1/Client2 inconsistency before publication. Redact tenant IDs, device IDs, UPNs, incident IDs, request IDs, public IPs and any customer information.
