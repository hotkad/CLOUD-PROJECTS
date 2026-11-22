# Production hardening

The lab implements a focused set of controls. Production adoption requires broader governance, resilience and monitoring.

## Defender for Cloud
- Establish subscription and management-group scope, ownership and policy baselines.
- Review Defender for Servers Plan 2 features, prerequisites, costs and data residency.
- Integrate alerts with Microsoft Sentinel or the organisation's SIEM.
- Define alert routing, incident ownership, severity and response SLAs.
- Track recommendations through risk-based remediation plans.

## VM management
- Prefer Azure Bastion or private management connectivity over public RDP.
- Require MFA, privileged identity management and just-enough administration.
- Use Azure Policy and machine configuration to assess configuration drift.
- Deploy Guest Configuration consistently through policy/Defender-native workflows and monitor extension health.

## Key Vault
- Use private endpoints and private DNS for sensitive vaults where practical; remove public access when validated.
- Retain default-deny network rules and explicit workload access.
- Use managed identities and least-privilege data-plane roles.
- Enable soft delete and purge protection in line with recovery policy.
- Monitor secret access, permission changes, firewall changes and purge attempts.

## Azure SQL
- Use private endpoints and private DNS.
- Disable public network access after validating dependencies.
- Enforce Entra authentication where appropriate, least-privilege database roles and auditing.
- Alert on firewall, network and private endpoint connection changes.

## Operational acceptance
All in-scope VMs have verified Guest Configuration and healthy assessment; JIT is configured for approved administrators; Key Vault allowed/denied tests pass; SQL DNS and traffic use the private endpoint; monitoring, rollback, ownership and cost reviews are complete.
