# CLOUD-PROJECTS — Cloud Security Engineering Portfolio

A collection of practical cloud security, identity, infrastructure and security operations projects. Each project is maintained independently and distinguishes observed lab outcomes from planned work and production recommendations.

## Featured Microsoft security projects

| Project | Focus | Status |
|---|---|---|
| [Microsoft Entra GSA — Zero Trust Private Access](Projects/Microsoft-Entra-GSA-ZTNA-Lab) | Identity-aware access, app segmentation, Conditional Access, private DNS, NSG path validation | Lab implementation documented |
| [Microsoft Defender for Cloud — Contoso Hardening](Projects/Microsoft-Defender-for-Cloud-Contoso-Lab) | Defender for Servers, JIT, Key Vault network controls, purge protection, SQL Private Link | Lab implementation documented; Guest Configuration coverage needs further validation |
| [Microsoft Defender XDR — Endpoint Detection & Response](Projects/Microsoft-Defender-XDR-Endpoint-Detection-Response-Lab) | Onboarding, ASR, incident investigation, KQL detection, Live Response, containment | Lab implementation documented |
| [Microsoft Sentinel — Hybrid SIEM](Projects/Microsoft-Sentinel-Hybrid-SIEM-Implementation) | Log Analytics, AMA/DCR, Windows/Linux telemetry, KQL, Azure Arc and WEF | Core cloud/Linux collection documented; hybrid collector ingestion remains in progress |
| [Active Directory — Paris Branch Deployment](Projects/Active-Directory-Paris-Branch-Deployment) | AD DS, sites/subnets, domain controller promotion, FSMO, delegation, FGPP, GPO | GUI runbook and validation plan |
| [Microsoft Foundry — AI Security Configuration](Projects/Microsoft-Foundry-AI-Security-Configuration-Lab) | AI workload security, RBAC, diagnostics, storage identity, content safety | In progress; ProjectX blocklist remains unresolved |

## Additional cloud and infrastructure projects

The [INTERNSHIP PROJECTS](INTERNSHIP%20PROJECTS) directory contains source reports and learning-project PDFs covering:
- Azure RBAC and Privileged Identity Management.
- AWS IAM and access security.
- AWS VPC, EC2 networking, private connectivity and network security.
- Static website hosting with Amazon S3.
- AWS analytics with QuickSight.

These are kept separate from the six standalone implementation projects above. Their PDFs are source deliverables; they should not be presented as IaC repositories or independently repeatable deployments unless the underlying configurations and evidence are added.

## Documentation standard

Each standalone project aims to include:
1. Business problem and requirements.
2. Architecture and trust boundaries.
3. Security design decisions and threat model.
4. Implementation runbook and configuration.
5. Actual deployment evidence (sanitised).
6. Validation and test results.
7. Misconfiguration, troubleshooting and remediation.
8. Limitations, residual risk and lessons learned.

A documented procedure is not proof of deployment. Project status and validation claims are intentionally qualified.

## Portfolio audit

See [PORTFOLIO-AUDIT.md](PORTFOLIO-AUDIT.md) for the November 2026 documentation audit, readiness scores, technical discrepancies and evidence priorities.

## Repository principles
- Keep projects independent; do not combine GSA with Sentinel, Foundry, Defender or Active Directory.
- Do not publish credentials, tokens, tenant/subscription IDs, customer data, raw forensic exports or unredacted screenshots.
- Use synthetic identities and RFC1918 lab addresses in examples.
- Review scripts before execution; examples are not production deployment templates.
- Record incomplete tasks and blockers accurately.

**Focus:** Cloud Security Engineering · Azure Security · Microsoft Entra ID · Zero Trust · Identity & Access Management · Network Security · Defender XDR · Microsoft Sentinel · Hybrid Infrastructure
