# Microsoft Sentinel — Hybrid SIEM Implementation Lab

**Author:** Honesty Dogunro  
**Project period:** 13–27 (as recorded in the source report; month/year not specified)  
**Platform:** Microsoft Sentinel, Azure Monitor Agent, Log Analytics, Azure Arc, Windows Server, Ubuntu Linux

A practical SIEM engineering project documenting deployment of Microsoft Sentinel, onboarding of Azure and Linux telemetry, Windows security-event collection, hybrid log forwarding design, KQL validation, analytics and automated incident notification.

> **Status accuracy:** Modules 1 and 2 are recorded as complete. Module 3 (Azure Arc / hybrid forwarding) is in progress. Module 4 (detection and automation) is partially complete. The report documents successful log forwarding from the domain controller to the on-premises collector, but the complete hybrid-to-Sentinel ingestion path is not recorded as validated.

## Executive summary

The project established a cloud-native SIEM foundation using the Log Analytics workspace `SentinelLAW-Honesty` in East US 2 and connected Microsoft Sentinel. Three Azure data sources were integrated: Microsoft Entra ID, Microsoft Defender for Cloud and Azure Network Security Groups. Azure Monitor Agent (AMA) and a Data Collection Rule were deployed to Windows virtual machines. An Ubuntu Linux VM was configured to forward selected rsyslog events, with ingestion verified in Sentinel using KQL.

The hybrid phase introduced a Windows Server 2022 log collector, Azure Arc onboarding, VPN connectivity and WinRM-based Windows Event Forwarding. The operationalisation phase included UEBA, a failed-logon analytic rule and a Logic App email playbook. The source report marks these later modules as in progress/partially complete; this repository preserves those distinctions.

## Architecture

~~~mermaid
flowchart TB
 subgraph Azure["Azure cloud"]
  LAW["Log Analytics workspace\nSentinelLAW-Honesty"]
  SENT["Microsoft Sentinel"]
  ENTRA["Microsoft Entra ID logs"]
  DEF["Defender for Cloud alerts"]
  NSG["NSG flow logs"]
  AMA["Azure Monitor Agent + DCR"]
  WIN["Windows VMs + Domain Controller"]
  LINUX["Ubuntu EP3-VM-Linux\nrsyslog / Syslog"]
  ENTRA --> LAW
  DEF --> LAW
  NSG --> LAW
  AMA --> LAW
  WIN --> AMA
  LINUX --> LAW
  LAW --> SENT
 end
 subgraph Hybrid["Hybrid lab — validation in progress"]
  COL["Windows Server 2022\nLOG-COLLECTOR"]
  DC["Domain Controller"]
  ARC["Azure Arc"]
  VPN["VPN connectivity"]
  DC -->|"WinRM / Windows Event Forwarding"| COL
  COL --> ARC
  VPN --- COL
 end
 SENT -. "Target: hybrid telemetry integration" .- ARC
~~~

## Implementation status

| Module | Scope | Status from source report |
|---|---|---|
| 1 | Sentinel deployment, workspace, connectors, AMA/DCR and Windows telemetry | **Complete** |
| 2 | Ubuntu Linux onboarding, rsyslog and Syslog ingestion validation | **Complete** |
| 3 | Azure Arc onboarding and Windows Event Forwarding via LOG-COLLECTOR | **In progress** |
| 4 | UEBA, failed-logon analytics, Logic App playbook and automation validation | **Partially complete** |

## What this project demonstrates
- SIEM deployment and Log Analytics workspace integration.
- Azure Monitor Agent and Data Collection Rule configuration.
- Windows and Linux telemetry onboarding.
- Syslog facility filtering and end-to-end ingestion verification.
- KQL-based log validation and threat detection.
- Azure Arc and hybrid log-forwarding concepts.
- Windows Event Forwarding / WinRM troubleshooting.
- UEBA and Logic App-based alert notification.

## Repository contents
- `docs/architecture-and-scope.md` — environment, architecture and module boundaries.
- `docs/deployment-runbook.md` — Sentinel, AMA/DCR and Linux onboarding sequence.
- `docs/hybrid-forwarding.md` — Arc, VPN, WinRM and event collector status.
- `docs/detection-and-automation.md` — KQL examples, analytics and Logic App workflow.
- `docs/troubleshooting-and-lessons.md` — layered troubleshooting approach and observations.
- `docs/validation-matrix.md` — what is complete, partial and still to validate.
- `queries/sentinel-validation.kql` — log validation and detection query examples.
- `config/project-status.csv` — module status inventory.

## Important limitations
- The source report does not specify the project month/year; the dates 13th–27th are preserved without inventing a date.
- Module 3 is not marked complete. The report records successful DC-to-collector forwarding, but does not establish that the complete collector-to-Sentinel path was validated.
- Module 4 is partially complete. The report says failed-sign-in simulation created an incident and delivered an email, but the full rule configuration, thresholds and playbook definition are not included.
- The report references an Azure Network Security Group connector; validate the actual connector and table used in the tenant before describing the telemetry as NSG flow logs in a production design.

## References
- [Microsoft Sentinel documentation](https://learn.microsoft.com/azure/sentinel/)
- [Azure Monitor Agent overview](https://learn.microsoft.com/azure/azure-monitor/agents/azure-monitor-agent-overview)
- [Data Collection Rules](https://learn.microsoft.com/azure/azure-monitor/data-collection/data-collection-rule-overview)
- [Syslog via AMA](https://learn.microsoft.com/azure/sentinel/data-connectors/syslog-via-ama)
- [Azure Arc-enabled servers](https://learn.microsoft.com/azure/azure-arc/servers/overview)
- [Windows Event Forwarding](https://learn.microsoft.com/windows/security/operating-system-security/device-management/use-windows-event-forwarding-to-assist-in-intrusion-detection)

Cloud Security Engineering Portfolio · Microsoft Sentinel · SIEM · Hybrid Monitoring · KQL

## Design, threat model and evidence
- [Business requirements, design decisions and threat model](docs/design-and-risk-analysis.md)
- [Evidence register](evidence/README.md)
- [Azure network flow logging modernisation](docs/network-flow-logging-modernisation.md)

The source report's NSG Flow Logs configuration is historical. New NSG flow logs cannot be created after 30 June 2025 and the feature retires 30 September 2027; new deployments should use VNet flow logs. See the Microsoft lifecycle guidance.
