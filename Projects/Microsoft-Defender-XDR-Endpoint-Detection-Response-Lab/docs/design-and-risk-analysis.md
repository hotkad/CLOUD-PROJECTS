# Defender XDR — Business Requirements, Design Decisions and Threat Model

## Business problem
Endpoint security teams need to identify suspicious endpoint behaviour, investigate an incident, collect evidence, and contain a compromised device without losing critical forensic context.

## Business requirements
- Onboard a disposable Windows endpoint into Defender for Endpoint.
- Generate an authorised simulation event and investigate the resulting incident.
- Apply a targeted Attack Surface Reduction rule.
- Create a custom indicator from a validated, run-specific IOC.
- Create a KQL-based custom detection and define response actions.
- Use Live Response to inspect connections and collect an investigation package.
- Isolate the affected endpoint and record the containment outcome.

## Architecture
The lab uses Microsoft Defender XDR / Defender for Endpoint, Microsoft Intune, two Windows 11 VMs, a Defender device group (Group1) and an Entra security group (sg-Executive). Endpoint telemetry feeds Defender XDR; analysts investigate the incident, create an indicator and custom detection, collect forensic evidence, then isolate the endpoint.

## Security design decisions
| Decision | Rationale | Trade-off / residual risk |
|---|---|---|
| Disposable endpoint for simulation | Prevents impact to production assets | Lab telemetry and policy scope do not represent enterprise fleet diversity |
| Separate Defender device group and Entra group | Uses the correct group type for device automation versus policy assignment | Group membership and scope must be independently validated |
| Collect evidence before isolation when safe | Preserves volatile and forensic context | Immediate containment may take priority during active harm |
| Run-specific IOC | Avoids reusing stale or unrelated indicators | IP indicators can affect legitimate traffic; require confidence, expiry and scope review |
| Hourly custom detection | Matches the recorded lab task | Detection latency and false positives may be unacceptable for some use cases |
| Full automation on Group1 | Demonstrates automated response capability | High blast radius; unsuitable for broad production rollout without staged validation |

## Threat model
| Threat | Impact | Control / evidence | Residual risk / next test |
|---|---|---|---|
| Script-based execution and process injection | Endpoint compromise and credential/data access | Incident graph and process telemetry investigated | KQL parent/child relationship is a hunting clue, not proof of process injection; correlate memory/EDR evidence |
| Malicious network IOC | C2 or payload retrieval | Indicator created from current incident evidence | Validate reputation, action, expiry and scope; allow for policy propagation |
| Excessive automated remediation | Business interruption or data loss | Group1 scoped to lab Windows devices | Use staged rings and approval for sensitive systems |
| Evidence loss during containment | Reduced forensic capability | Package collection before isolation when safe | Preserve chain of custody, hash evidence and record operator/timestamps |
| Detection false positives | Alert fatigue or inappropriate response | KQL rule and validation matrix | Baseline normal PowerShell use, tune query, test entity mapping and response actions |
| Public disclosure of incident artifacts | Exposure of tenant, user or endpoint data | Sanitised documentation | Keep raw packages, onboarding scripts, incident IDs and IOC values out of Git |

## Important interpretation
The custom query detects a PowerShell-to-Notepad process relationship observed in the simulation. It is not a general-purpose process-injection detector. The source record also has a Client1/Client2 naming discrepancy across task headings and later response steps; confirm the actual device identity in Defender before reproducing or asserting endpoint-specific outcomes.

## Architecture decision records
- **ADR-01 — Disposable simulation endpoint:** run attack simulations only on isolated, authorised lab assets.
- **ADR-02 — Evidence before isolation:** collect volatile/forensic evidence first when safe; contain immediately if ongoing harm requires it.
- **ADR-03 — IOC confidence and scope:** use validated, expiring indicators and the narrowest practical device scope.
- **ADR-04 — Detection before automation:** test KQL, entity mappings and false positives before enabling automated remediation.
- **ADR-05 — Distinct group constructs:** use Defender device groups for device scope and Entra security groups for Entra/Intune policy assignment.
