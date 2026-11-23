# Architecture and scope

## Objective
Build and operationalise a Microsoft Sentinel SIEM environment that collects security telemetry from Azure, Windows and Linux systems, then extend the design toward hybrid log forwarding and automated alerting.

## Core components

| Component | Recorded configuration / role |
|---|---|
| Log Analytics workspace | SentinelLAW-Honesty |
| Resource group | DCR |
| Region | East US 2 |
| Pricing | Pay-as-you-go |
| SIEM | Microsoft Sentinel attached to existing workspace |
| Windows collection | Azure Monitor Agent with DCR-WindowsSecurityEvents-01 |
| DCR collection scope | All Security Events |
| Windows targets | Domain Controller, EP1-VM, EP2-VM |
| Linux endpoint | EP3-VM-Linux (Ubuntu) |
| Linux collection | rsyslog local4 facility via Syslog via AMA |
| Hybrid collector | LOG-COLLECTOR, Windows Server 2022 in VirtualBox |
| Hybrid connectivity | VPN, Azure Arc, WinRM / Windows Event Forwarding |

## Azure data sources recorded
- Microsoft Entra ID authentication and audit logs.
- Microsoft Defender for Cloud alerts.
- Azure Network Security Group telemetry (connector described in the source report).

## Data-flow model
1. Azure-native security sources and monitored endpoints send telemetry to Log Analytics.
2. Microsoft Sentinel uses the workspace as its SIEM data layer.
3. Windows endpoints use AMA and a Data Collection Rule.
4. Linux rsyslog forwards selected local4 events, collected through Syslog via AMA.
5. The hybrid extension uses Azure Arc for server management and Windows Event Forwarding to collect selected domain-controller events on LOG-COLLECTOR.

## Scope boundary
The hybrid collector's presence in Azure Arc and successful forwarding into its local Forwarded Events log are documented. A complete path from LOG-COLLECTOR through AMA into the Sentinel workspace is not confirmed in the source report and remains a validation item.
