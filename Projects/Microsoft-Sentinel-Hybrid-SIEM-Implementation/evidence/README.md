# Evidence register

No screenshots or raw log exports are currently committed here. Capture evidence from the actual tenant and lab endpoints. Do not publish raw security logs containing usernames, public IPs, hostnames, tenant identifiers or incident IDs.

## Evidence to capture
| ID | Evidence | Required validation |
|---|---|---|
| SIEM-01 | Log Analytics workspace and Sentinel attachment | Workspace, region and resource scope |
| SIEM-02 | Entra ID / Defender connector state | Connector status and relevant data tables |
| SIEM-03 | Windows AMA and DCR | Agent status, DCR association and SecurityEvent/Heartbeat query |
| SIEM-04 | Linux AMA / Syslog configuration | Syslog table contains expected local4 test messages |
| SIEM-05 | KQL validation output | Time range, host alias, event ID and ingestion timestamp |
| SIEM-06 | Azure Arc collector | LOG-COLLECTOR connected and healthy |
| SIEM-07 | WEF Forwarded Events | Selected event IDs received locally |
| SIEM-08 | Collector-to-Sentinel ingestion | Forwarded events appear in Log Analytics/Sentinel; currently pending |
| SIEM-09 | Analytic and incident | Rule query, threshold, entity mapping and incident creation |
| SIEM-10 | Logic App notification | Successful test delivery and restricted recipient scope |

Use redacted samples and synthetic test messages. Retain raw logs in the lab only.
