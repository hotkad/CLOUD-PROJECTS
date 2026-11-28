# Microsoft Sentinel — Business Requirements, Design Decisions and Threat Model

## Business problem
Security operations require centralised visibility across Azure-native services, Windows endpoints and Linux systems. Hybrid log forwarding is also needed so that selected on-premises security events can be investigated alongside cloud telemetry.

## Business requirements
- Establish a Log Analytics workspace and enable Microsoft Sentinel.
- Ingest Entra ID and Defender for Cloud telemetry.
- Collect Windows Security Events using Azure Monitor Agent (AMA) and a Data Collection Rule.
- Collect selected Linux Syslog messages and validate ingestion with KQL.
- Extend monitoring to a hybrid Windows Server collector using Azure Arc and Windows Event Forwarding.
- Implement a failed-logon analytic and notification workflow.
- Clearly distinguish completed ingestion paths from partially implemented hybrid paths.

## Architecture
Azure-native sources and monitored endpoints send telemetry to Log Analytics; Microsoft Sentinel uses the workspace as its SIEM data layer. Windows VMs use AMA and a DCR. Ubuntu uses rsyslog and Syslog via AMA. The hybrid design uses LOG-COLLECTOR, Azure Arc, VPN and Windows Event Forwarding. The source report confirms DC-to-collector forwarding, but does not prove the final collector-to-Sentinel path.

## Security design decisions
| Decision | Rationale | Trade-off / residual risk |
|---|---|---|
| Existing Log Analytics workspace | Keeps Sentinel and collected data in one workspace for the lab | Workspace access, retention and cost need governance |
| AMA + DCR for Windows | Centralises collection configuration and endpoint association | Collecting All Security Events can generate high volume and cost |
| Syslog via AMA for Linux | Uses supported agent-based collection and table-based validation | Facility/severity selection must match detection requirements |
| KQL validation before analytics | Proves data arrival before relying on detections | Ingestion delay and schema changes can affect query results |
| Hybrid forwarding as a separate workstream | Avoids claiming end-to-end ingestion based only on local Forwarded Events | Module remains incomplete until AMA/DCR/Sentinel query succeeds |
| Failed-logon analytic and email playbook | Demonstrates detection and notification | Exact threshold/query and playbook error handling were not preserved |

## Threat model
| Threat | Impact | Control / evidence | Residual risk / next test |
|---|---|---|---|
| Missing telemetry | Attacks remain invisible | Heartbeat, Syslog and SecurityEvent KQL validation | Alert on ingestion gaps and agent health |
| Excessive event collection | Cost increase and analyst noise | DCR and facility filtering | Replace All Security Events with a risk-based collection profile |
| Log tampering or deletion | Reduced investigation reliability | Central workspace and RBAC | Add immutable/retained archive where required, monitor workspace and DCR changes |
| Compromised collector | Attacker manipulates or suppresses forwarded events | Arc/AMA and restricted network design | Harden collector, restrict WinRM, use least-privilege service identities |
| Misconfigured WEF/WinRM | Hybrid events fail to arrive or are exposed | Collector-initiated subscription and network restrictions | Verify listener, firewall, subscription, AMA, DCR and Sentinel table end to end |
| Alert fatigue / weak detection | Missed incidents or unnecessary response | KQL analytics and UEBA | Record threshold, lookback, entity mapping, suppression and false-positive tests |
| Notification leakage | Incident details sent to unauthorised recipients | Logic App email notification | Limit recipients, minimise payload, secure connections and audit changes |

## Current NSG flow-log lifecycle
The original report describes NSG Flow Logs v2 with Traffic Analytics. Microsoft states that new NSG flow logs can no longer be created after 30 June 2025 and the feature retires on 30 September 2027. Treat this as a historical lab configuration; new monitoring designs should use Virtual Network flow logs and validate the current Traffic Analytics/Sentinel ingestion path. Do not describe an old NSG connector as a newly deployable architecture.

## Architecture decision records
- **ADR-01 — Central Log Analytics workspace:** use one lab workspace as the Sentinel data layer.
- **ADR-02 — AMA and DCR:** use agent-based collection with explicit DCR associations for Windows/Linux.
- **ADR-03 — Validate ingestion before detection:** prove the table and fields exist before building an analytic.
- **ADR-04 — Risk-based event collection:** retain All Security Events only as the recorded lab choice; tune production collection to detection needs and cost.
- **ADR-05 — Hybrid pipeline completion gate:** do not mark hybrid ingestion complete until collector events appear in the target Sentinel table.
- **ADR-06 — Flow-log migration:** use VNet flow logs for new Azure network-flow monitoring rather than attempting to create new NSG flow logs.

## Production acceptance gates
Complete the LOG-COLLECTOR → AMA → DCR → Log Analytics → Sentinel path; document analytic thresholds and playbook permissions; tune event volume/retention; configure workspace RBAC; add ingestion-gap alerts and incident ownership.
