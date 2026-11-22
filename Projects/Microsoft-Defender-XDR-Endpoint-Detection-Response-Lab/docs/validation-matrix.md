# Validation matrix

| ID | Control | Evidence to retain | Recorded result |
|---|---|---|---|
| V-01 | Defender XDR workspace | Incidents workspace available | Provisioned |
| V-02 | Defender device group | Group1; Windows 10/11; Full automation | Created |
| V-03 | Client2 onboarding | Device inventory record; Streamlined connectivity | Onboarded |
| V-04 | Attack simulation | Incident and alert evidence | Incident generated |
| V-05 | ASR policy | EndpointPolicy1 rule state and sg-Executive assignment | Configured |
| V-06 | Incident triage | Incident graph, three alerts, Evidence tab | Investigated |
| V-07 | Custom IOC | Indicator1 configuration; dynamic IP excluded from repo | Created |
| V-08 | Custom detection | SuspiciousPowershell query and rule configuration | Created |
| V-09 | Live Response | Session record and connections output | Run |
| V-10 | Forensic collection | Action center completion and evidence export | Collected |
| V-11 | Isolation | Device action status | Client2 isolated |

## Additional production validation
- Confirm onboarding health and sensor connectivity.
- Confirm ASR policy is received and effective on a test device.
- Verify indicator action and scope using a safe test IOC, not a live malicious address.
- Test detection query against historical data and review false positives.
- Verify custom detection entity mappings and response actions.
- Confirm Live Response RBAC and audit events.
- Validate evidence retention, integrity and chain of custody.
- Confirm device isolation and recovery procedures.

## Evidence redaction
Remove tenant/subscription identifiers, device names/IDs, UPNs, incident IDs, public IP indicators, onboarding package contents, tokens and customer information.
