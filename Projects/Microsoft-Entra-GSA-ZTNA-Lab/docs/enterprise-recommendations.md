# Enterprise-scale recommendations

The lab demonstrates selected access and network-path behaviours. Production requires additional availability, governance, monitoring and operational controls.

## Identity and endpoint
- Deploy the GSA client through Intune using a supported Win32/native method, version-aware detection and staged pilot rings.
- Resolve Conditional Access interactions with Intune enrollment before broad rollout.
- Apply device compliance baselines (supported OS, patch level, BitLocker, Defender health) and require compliant-device signals where supported.
- Use separate privileged identities, phishing-resistant MFA for administrators and least-privilege Entra roles.
- Add tenant association and device-registration checks to VM import/onboarding procedures.

## Network and connector resilience
- Deploy at least two Private Network Connectors per connector group across appropriate failure domains.
- Monitor connector health, capacity, service connectivity and application reachability.
- Publish per-application segments with the smallest practical destination, port and protocol scope.
- Include RPC dependencies explicitly for AD management; constrain dynamic RPC exposure where supported and validated.
- Ensure no direct route, peering, VPN, firewall rule or alternate proxy unintentionally bypasses GSA policy.

## Policy and governance
- Use governed Entra groups, Entitlement Management access packages, approval workflows and periodic access reviews instead of ad hoc individual assignments.
- Keep Assignment required enabled where the application access model requires explicit assignment.
- Apply risk-aware Conditional Access, session controls and emergency-access exclusions with documented rationale.
- Treat Internet Access security profiles as complementary controls, not a substitute for Private Access segmentation.
- Alert on assignment changes, privileged role changes, risky sign-ins, connector health and unusual access patterns.

## Migration and cutover
- Run legacy VPN and Private Access in parallel during per-application migration.
- Use GSA traffic logs and application telemetry to identify remaining legacy-path usage.
- Validate user experience, DNS, dependencies and failover before removing legacy routes.
- Decommission VPN/firewall access only after agreed evidence thresholds and rollback planning.
- Maintain change records, ownership, support procedures and an exception register.

## Operational acceptance criteria
- Connector redundancy and recovery are tested.
- Every application has an owner, data classification, dependency map and approved access group.
- Direct/alternate access paths are assessed.
- Conditional Access and device compliance are tested against enrollment and break-glass paths.
- Logging, alerting, support and rollback procedures are operational.
