# Engagement overview

## Objective
Execute a controlled endpoint detection and response exercise using Microsoft Defender XDR and Intune. The workflow covered endpoint onboarding, attack simulation, incident triage, prevention policy, custom detection, forensic collection and containment.

## Environment
- Microsoft Defender XDR / Microsoft Defender for Endpoint
- Microsoft Intune
- Hosted lab tenant
- Two Windows 11 virtual machines: Client1 and Client2
- Entra security group: sg-Executive
- Defender device group: Group1

## Workstreams and results

| Task | Implementation | Result |
|---|---|---|
| Workspace preparation | Provision Defender XDR incident and alert workspace | Portal provisioned |
| Device grouping | Group1, Full automation, Windows 10/11 OS condition | Created |
| Endpoint onboarding | Client2, Local Script, Streamlined connectivity | Visible in Defender device inventory |
| Simulation | Run supplied AttackScript.ps1 after onboarding | Incident generated |
| ASR policy | EndpointPolicy1; block JavaScript/VBScript from launching downloaded executable content | Assigned to sg-Executive |
| Incident investigation | Review incident graph and Evidence tab | Three alerts; PowerShell-to-Notepad process injection observed |
| IOC | Add run-specific malicious IP as Indicator1 | Block execution; High severity; Execution category; lab-wide scope |
| Detection | SuspiciousPowershell custom detection | Hourly; all devices; collect investigation package and mark user compromised |
| Forensics | Live Response, inspect connections, collect package | Completed; CSV evidence export saved in lab |
| Containment | Isolate Client2 after collection | Isolated |

## Naming and evidence caveat
The source write-up refers to Client2 as the onboarded and simulated endpoint, while headings for the ASR and incident investigation tasks refer to Client1. The forensic response section explicitly opens Live Response on Client2 and isolates Client2. This project preserves the recorded outcomes and calls out this naming inconsistency rather than silently asserting that every task was performed on the same endpoint.

## Device groups versus Entra groups
Group1 is a Defender for Endpoint device group, used for device organisation and automation scope. sg-Executive is an Entra security group, used for policy assignment. They are separate identity and control constructs.
