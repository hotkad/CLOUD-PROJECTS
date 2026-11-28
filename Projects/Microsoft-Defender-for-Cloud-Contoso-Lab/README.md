# Microsoft Defender for Cloud — Contoso Security Hardening Lab

A practical Azure security implementation lab simulating a scoped consulting engagement for Contoso Ltd. The work translates stakeholder requirements into minimum-change cloud security controls, deploys them through Azure portal and Azure CLI, and verifies configuration.

**Author:** Honesty Dogunro  
**Date:** November 2026  
**Environment:** Azure lab subscription · Resource group: RG1

> Sanitised portfolio reconstruction. Resource names and identifiers are generalised. This is not a production deployment template or a claim of full enterprise Defender for Cloud maturity.

## Executive summary

The engagement required six controls:
1. Enable Microsoft Defender for Servers Plan 2.
2. Configure Just-in-Time (JIT) RDP access on VM1 with a one-hour maximum request duration.
3. Restrict Azure Key Vault network access to Subnet1-1.
4. Enable Key Vault purge protection.
5. Create an Azure SQL private endpoint and verify its connection state is Approved.
6. Deploy the Guest Configuration extension to Azure VMs.

The lab passed configuration checks for Defender for Servers Plan 2, Key Vault network restrictions, purge protection and the SQL private endpoint. JIT was initially blocked because VM1 did not appear in the eligible list; after plan propagation and troubleshooting, it was configured. The Guest Configuration extension was installed on VM1 and reported provisioning state Succeeded. The original assessment still flagged posture/vulnerability management, so that item is marked as requiring further validation rather than presented as fully resolved.

## Architecture

~~~mermaid
flowchart TB
  subgraph Azure["Azure subscription — RG1"]
    subgraph VNet["Virtual network"]
      S1["Subnet1-1"]
      VM["VM1 / Azure VMs"]
      SQLPE["SQL private endpoint"]
    end
    DC["Microsoft Defender for Cloud\nServers Plan 2"]
    KV["Azure Key Vault\nSelected network only\nPurge protection enabled"]
    SQL["Azure SQL logical server"]
    GC["Guest Configuration extension"]
    JIT["JIT RDP · TCP 3389\nMaximum 1 hour"]
    DC --> JIT
    DC --> GC
    VM --> GC
    S1 --> KV
    S1 --> SQLPE
    SQLPE --> SQL
  end
~~~

## Repository contents
- docs/implementation-overview.md — requirements, architecture and outcomes
- docs/deployment-runbook.md — ordered implementation and verification
- docs/security-design.md — control rationale and boundaries
- docs/troubleshooting-and-lessons.md — blockers and corrective actions
- docs/validation-matrix.md — evidence checklist and completion status
- docs/production-hardening.md — enterprise recommendations
- scripts/ — sanitised Azure CLI examples
- config/ — control inventory

## Results

| Control | Source-lab result |
|---|---|
| Defender for Servers Plan 2 | Passed |
| JIT RDP on VM1, one-hour maximum | Configured on second attempt |
| Key Vault firewall limited to Subnet1-1 | Passed |
| Key Vault purge protection | Passed |
| SQL private endpoint connection | Approved |
| Guest Configuration extension | VM1 extension succeeded; broader posture check remained unresolved |

## Key engineering lessons
- Enable Defender for Servers Plan 2 before attempting dependent capabilities such as JIT.
- Eligible-resource lists and recommendations may take time to update after plan enablement.
- A successful VM extension deployment is not equivalent to a passed Defender posture or vulnerability-management assessment.
- Key Vault network rules, service endpoints, private endpoints and data-plane permissions solve different parts of access control.
- Verify private endpoint approval and DNS resolution; creating the endpoint alone does not prove clients use it.
- Make the smallest required change set. Optional Defender plans were not enabled because they were outside the stated requirements.

## References
- [Microsoft Defender for Cloud](https://learn.microsoft.com/azure/defender-for-cloud/)
- [Defender for Servers plans](https://learn.microsoft.com/azure/defender-for-cloud/plan-defender-for-servers-select-plan)
- [JIT VM access](https://learn.microsoft.com/azure/defender-for-cloud/just-in-time-access-overview)
- [Key Vault network security](https://learn.microsoft.com/azure/key-vault/general/network-security)
- [Purge protection](https://learn.microsoft.com/azure/key-vault/general/soft-delete-overview)
- [Azure Private Endpoint](https://learn.microsoft.com/azure/private-link/private-endpoint-overview)
- [Guest Configuration](https://learn.microsoft.com/azure/governance/machine-configuration/overview)

## Design, threat model and evidence
- [Business requirements, design decisions and threat model](docs/design-and-risk-analysis.md)
- [Evidence register](evidence/README.md)
- [SQL private DNS validation](docs/evidence/sql-private-dns-validation.md)
- [SQL private DNS deployment example](scripts/sql-private-dns.sh)

The SQL private endpoint is not end-to-end validated until private DNS resolution and client connectivity are tested. Guest Configuration remains partially evidenced; see the validation matrix.
