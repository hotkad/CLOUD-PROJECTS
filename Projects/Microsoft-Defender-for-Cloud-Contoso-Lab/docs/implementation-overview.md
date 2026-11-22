# Implementation overview

## Engagement context
A simulated consulting task for Contoso Ltd. Stakeholder instructions from the CTO, Security Administrator and Network Administrator were translated into six specific Azure configuration outcomes. Constraints: keep resources in RG1, use defaults unless a requirement required otherwise, and make the least administrative change necessary.

## Requirements and outcomes

| # | Requirement | Implementation | Source outcome |
|---:|---|---|---|
| 1 | Enable Defender for Cloud — Servers | Onboard subscription and enable Defender for Servers Plan 2 | Passed |
| 2 | JIT on VM1, RDP only, max one hour | Enable JIT for TCP 3389; set maximum request duration to one hour | Configured after initial eligibility issue |
| 3 | Key Vault accessible only from Subnet1-1 | Microsoft.KeyVault service endpoint; selected-network firewall; default action Deny | Passed |
| 4 | Key Vault purge protection | Enable purge protection | Passed |
| 5 | Azure SQL private endpoint | Create endpoint in Subnet1-1; verify connection state | Approved |
| 6 | Guest Configuration extension on Azure VMs | Assign managed identity and deploy extension | VM1 succeeded; posture/vulnerability check remained unresolved |

## Scope
- Azure subscription and resource group RG1.
- Existing VNet and Subnet1-1 (names abstracted).
- VM1 and other Azure VMs in scope for Guest Configuration.
- Azure Key Vault with selected-network access.
- Azure SQL logical server and private endpoint.
- Microsoft Defender for Cloud Servers Plan 2.

The source report explicitly records extension deployment for VM1. It does not provide sufficient evidence to claim successful deployment to every VM. This portfolio distinguishes the requirement from the verified result.

## Outcome interpretation
A control may be configured while a related recommendation or assessment remains pending. VM extension provisioning success is evidence of deployment to that VM; it is not proof that all machines are covered or all configuration assessments are healthy.
