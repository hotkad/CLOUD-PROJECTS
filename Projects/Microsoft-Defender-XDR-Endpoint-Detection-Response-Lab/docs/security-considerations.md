# Security considerations and production hardening

## Simulation safety
The source lab reports that AMSI blocked the attack script. Tamper Protection and real-time protection were temporarily disabled on a disposable lab VM to permit the simulation. This is recorded as a lab-specific workaround only.

Never disable endpoint protection on production or employee devices to run an attack script. Use an isolated test tenant/VM, approved simulation tooling, documented authorisation and a rollback plan.

## Automated remediation scope
Group1 was configured with Full automation. This can trigger automated remediation. Production deployment should use narrowly scoped device groups, automation policy by device criticality, pilot/ring deployment, monitoring, rollback and clear ownership.

## IOC quality and blast radius
The malicious IP was dynamic and deliberately omitted. Validate IOC confidence, context, expiry and scope before creating a block indicator. An incorrect organisation-wide indicator can disrupt legitimate services.

## Detection quality
The lab KQL detects a specific PowerShell-to-Notepad process relationship. It is a demonstration analytic, not a comprehensive process-injection detector. Tune with additional telemetry, baseline data, false-positive testing and peer review.

## Identity and policy assignment
Defender device groups and Entra security groups are different constructs. Verify the correct group type and assignment target for each control. Check policy assignment status and endpoint check-in rather than assuming creation equals enforcement.

## Incident response order
Collect volatile and forensic evidence before isolation when safe. If active harm is ongoing, containment may take priority; follow the incident commander and response playbook.

## Public repository hygiene
Never publish onboarding packages, tenant IDs, device IDs, UPNs, incident IDs, raw IP indicators, forensic archives, access tokens or unredacted screenshots.
