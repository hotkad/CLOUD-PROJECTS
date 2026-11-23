# Validation matrix

| ID | Validation | Evidence described in source report | Status |
|---|---|---|---|
| S-01 | Log Analytics workspace | SentinelLAW-Honesty in East US 2 | Complete |
| S-02 | Sentinel enablement | Attached to existing workspace | Complete |
| S-03 | Azure connectors | Entra ID, Defender for Cloud, NSG connector | Complete (as reported) |
| S-04 | Windows AMA | Extension Succeeded on DC, EP1-VM, EP2-VM | Complete |
| S-05 | Windows DCR | DCR-WindowsSecurityEvents-01; All Security Events | Complete |
| S-06 | Windows heartbeat | Heartbeat query confirmed reporting | Complete |
| S-07 | Linux onboarding | EP3-VM-Linux, rsyslog and AMA | Complete |
| S-08 | Linux syslog | local4 messages visible in Syslog table | Complete |
| S-09 | Linux cadence | 30-minute test interval verified | Complete |
| S-10 | Azure Arc | LOG-COLLECTOR appeared in Arc Machines | Complete |
| S-11 | DC to collector forwarding | Events visible in Forwarded Events log | Complete |
| S-12 | Collector to Sentinel ingestion | No end-to-end validation recorded | Pending |
| S-13 | UEBA | Enabled | Complete (as reported) |
| S-14 | Failed-logon analytic | Incident created during simulation | Partially complete |
| S-15 | Logic App notification | Email playbook attached and test delivery reported | Partially complete |

## Remaining work
- Complete and validate the LOG-COLLECTOR → AMA → DCR → Log Analytics → Sentinel pipeline.
- Document the exact analytic query, threshold, lookback period and entity mappings.
- Record the playbook workflow, connections, permissions and failure handling.
- Validate the NSG data connector/table and clarify whether the source was flow logs or another NSG diagnostic source.
- Add cost controls, retention, workspace RBAC and data access governance.
- Capture redacted screenshots and query results for each validation row.
