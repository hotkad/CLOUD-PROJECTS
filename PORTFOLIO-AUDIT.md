# Cloud Security Portfolio — Audit and Improvement Plan

**Repository:** [hotkad/CLOUD-PROJECTS](https://github.com/hotkad/CLOUD-PROJECTS)  
**Audit date:** 28 November 2026  
**Scope:** Six standalone project directories, their Markdown documentation, scripts, configuration files, KQL and repository index. PDF source materials were inventoried; not every multi-page PDF has been independently revalidated in this audit.

## Executive assessment
The portfolio has credible practical breadth across Zero Trust, cloud posture, endpoint detection/response, SIEM, Active Directory and AI security. The strongest differentiator is troubleshooting and validation detail, especially in the GSA project. The main weakness is not project count; it is uneven evidence, inconsistent status reporting and missing explicit business/design/threat-model sections.

The scores below measure **portfolio documentation readiness**, not technical skill, deployment success or hiring probability.

| Project | Score / 16 | Current assessment |
|---|---:|---|
| Entra GSA / ZTNA | 13 | Strong architecture, negative tests and troubleshooting; needs committed evidence and consistency fixes |
| Defender for Cloud | 11 | Good implementation record; SQL DNS and all-VM Guest Configuration evidence incomplete |
| Defender XDR | 11 | Good incident/detection narrative; endpoint naming and detection validation need tightening |
| Sentinel | 11 | Good Azure/Windows/Linux foundation; hybrid collector-to-Sentinel path incomplete |
| Active Directory Paris | 10 | Detailed GUI runbook; actual validation/evidence not yet committed |
| Foundry AI Security | 6 | In progress; ProjectX blocklist remains a blocker |

## Eight-point review
1. Business requirements and problem statement.
2. Architecture diagram and trust boundaries.
3. Security architecture, design decisions and threat model.
4. Implementation steps and configuration.
5. Actual deployment evidence.
6. Validation and test results.
7. Misconfiguration, troubleshooting and remediation.
8. Limitations, residual risk and lessons learned.

Scores reflect documentation present at audit time. A missing screenshot does not mean the work was not done; it means a public reviewer cannot verify it from the repository.

## Cross-project findings
- Evidence: no dedicated, populated evidence sets were present in the six project directories at audit time. Evidence registers have been added; they are not evidence themselves.
- Design rationale: implementation detail existed, but business requirements, ADRs and threat models were inconsistent. New design/risk documents have been added.
- GSA naming: the IIS script used `ops.labcorp.local`, while the architecture and DNS used `admin.labcorp.local`. Standardise the IIS script and inventory to the Admin naming only after checking the actual lab binding.
- GSA network script: attaching a newly created NSG to a NIC can replace an existing association. Review effective rules and preserve/merge existing policy before attaching.
- Defender for Cloud: SQL private endpoint creation alone does not establish private DNS resolution. Add the recommended private DNS zone and link; test using the normal SQL FQDN.
- Defender XDR: Client1/Client2 references differ across source sections. Verify the actual device in Defender before publishing endpoint-specific screenshots.
- Sentinel: the source project refers to NSG Flow Logs. New NSG flow logs cannot be created after 30 June 2025 and the feature retires 30 September 2027; document the historic lab configuration and use VNet flow logs for new builds.
- Foundry: ProjectX blocklist creation is not complete. Keep the project marked In progress until the filter is created and tested.
- Repository indexing: the root README did not index all six project folders, including Foundry and Active Directory, and did not clearly distinguish internship PDF materials from standalone implementation projects.

## Evidence collection priority
1. GSA: connector health, application segments, assignment required, authorised access, AADSTS50105 negative test, DNS/NRPT, effective NSG and bypass test.
2. Defender for Cloud: Servers Plan 2, JIT, Key Vault network rule, purge protection, SQL private DNS and endpoint resolution, Guest Configuration per VM.
3. Defender XDR: endpoint inventory, ASR assignment/effectiveness, incident graph, IOC metadata (redact value), detection configuration, Live Response, collection and isolation.
4. Sentinel: workspace/Sentinel, connectors, AMA/DCR, Windows and Linux queries, Arc/WEF, end-to-end collector ingestion, analytic and Logic App.
5. Active Directory: site/subnet, DC2/replication/RID, OU delegation, password policies, Recycle Bin, exact NTLM setting, GPO scope.
6. Foundry: plans, RBAC, diagnostics, storage Entra connection, guardrails, ProjectX blocklist and Filter1 state.

## Recommended next actions
- Capture real, sanitised evidence in each `evidence/` folder.
- Resolve the explicit code/documentation discrepancies before claiming reproducibility.
- Complete the Sentinel hybrid ingestion path and Foundry blocklist blocker.
- Add a short project-specific demo or walkthrough to the top three projects.
- Keep each project independent; do not merge the GSA project with Sentinel, Foundry, Defender or Active Directory.
- Re-score only after evidence and validation have been added.

## Source references
- [Microsoft Entra Global Secure Access](https://learn.microsoft.com/entra/global-secure-access/)
- [Microsoft Defender for Cloud](https://learn.microsoft.com/azure/defender-for-cloud/)
- [Microsoft Defender XDR](https://learn.microsoft.com/defender-xdr/)
- [Microsoft Sentinel](https://learn.microsoft.com/azure/sentinel/)
- [Active Directory Domain Services](https://learn.microsoft.com/windows-server/identity/ad-ds/)
- [Microsoft Foundry](https://learn.microsoft.com/azure/ai-foundry/)
- [NSG flow logs lifecycle](https://learn.microsoft.com/azure/network-watcher/network-watcher-nsg-flow-logging-overview)
- [Azure SQL private endpoint](https://learn.microsoft.com/azure/azure-sql/database/private-endpoint-overview)
