# Microsoft Defender XDR — Endpoint Detection, Investigation & Response Lab

**Author:** Honesty Dogunro  
**Date:** 22 November 2026  
**Platform:** Microsoft Defender XDR / Defender for Endpoint, Microsoft Intune  
**Environment:** Hosted lab tenant; two Windows 11 VMs (Client1 and Client2)

A hands-on endpoint security exercise covering device onboarding, attack simulation, incident triage, attack surface reduction (ASR), custom indicators of compromise, KQL detection engineering, Live Response, evidence collection and device containment.

> Portfolio integrity: This repository documents observed lab outcomes. It does not claim a production deployment. Tenant-specific data and run-specific IOC values are intentionally excluded.

## Executive summary

Defender XDR was provisioned, Client2 was onboarded, a controlled attack simulation generated an incident, and the incident artifacts were used to build a custom indicator and scheduled detection. An ASR policy was configured for the executive Entra security group. Live Response was used to inspect connections and collect an investigation package before isolating the simulated compromised endpoint.

## Recorded outcomes

| Workstream | Outcome |
|---|---|
| Defender XDR workspace | Provisioned |
| Device group | Group1 created; Full automation; Windows 10/11 scope |
| Endpoint onboarding | Client2 onboarded with Local Script and Streamlined connectivity |
| Attack simulation | Incident generated |
| ASR policy | EndpointPolicy1 blocks JavaScript/VBScript-launched downloaded executables; assigned to sg-Executive |
| Incident investigation | Three alerts and attack graph reviewed; process injection identified |
| Custom IOC | Indicator1 created from run-specific malicious IP; Block execution; High severity |
| Custom detection | SuspiciousPowershell scheduled hourly across all devices |
| Live Response | Session run; connections inspected; investigation package collected |
| Containment | Client2 isolated after evidence collection |

## Response workflow

~~~mermaid
flowchart TD
 A["Provision Defender XDR"] --> B["Create device group"]
 B --> C["Onboard endpoint"]
 C --> D["Run controlled simulation"]
 D --> E["Review incident and evidence"]
 E --> F["Extract run-specific IOC"]
 F --> G["Create custom indicator"]
 E --> H["Build KQL detection"]
 G --> I["Live Response and evidence collection"]
 H --> I
 I --> J["Isolate affected endpoint"]
 J --> K["Verify and document"]
~~~

## Project structure
- docs/engagement-overview.md — scope, architecture, task outcomes
- docs/implementation-runbook.md — ordered portal workflow and validation
- docs/incident-analysis.md — process injection evidence, IOC handling and triage
- docs/detection-engineering.md — KQL analytic and custom detection configuration
- docs/response-and-containment.md — Live Response, evidence handling and isolation
- docs/security-considerations.md — safety boundaries and production hardening
- docs/validation-matrix.md — completion evidence and known limitations
- detections/SuspiciousPowershell.kql — reusable hunting query
- config/lab-task-matrix.csv — task and outcome inventory

## Engineering observations
1. Onboard the endpoint before executing the simulation so endpoint telemetry is captured.
2. Public IPs and process IDs are run-specific. Extract the malicious address from current incident evidence; do not reuse stale IOC values.
3. The observed attack graph linked PowerShell to notepad.exe, identified as the process-injection target.
4. Inspect connections and collect forensic evidence before isolation where operationally safe.
5. Defender device groups and Entra security groups are different constructs.
6. Full automated remediation requires careful scoping and testing before production.

## Safety note
The source lab temporarily disabled Tamper Protection and real-time protection on a disposable VM because AMSI blocked the simulation script. This is a lab-only exception, not a recommended testing method. Production exercises should use an isolated, authorised test environment and approved simulation tooling. Never weaken protection on a business endpoint to make a test pass.

## References
- [Microsoft Defender XDR](https://learn.microsoft.com/defender-xdr/)
- [Defender for Endpoint onboarding](https://learn.microsoft.com/defender-endpoint/onboard-configure)
- [Attack surface reduction rules](https://learn.microsoft.com/defender-endpoint/attack-surface-reduction)
- [Advanced hunting](https://learn.microsoft.com/defender-xdr/advanced-hunting-overview)
- [Custom indicators](https://learn.microsoft.com/defender-endpoint/indicators-overview)
- [Live Response](https://learn.microsoft.com/defender-endpoint/live-response)
- [Collect investigation package](https://learn.microsoft.com/defender-endpoint/respond-machine-alerts)

Cloud Security & Endpoint Detection Engineering Portfolio · Microsoft Defender XDR · KQL · Incident Response

## Design, threat model and evidence
- [Business requirements, design decisions and threat model](docs/design-and-risk-analysis.md)
- [Evidence register](evidence/README.md)

The Client1/Client2 naming discrepancy in the source record must be resolved against the actual Defender device inventory before publishing endpoint-specific evidence.
