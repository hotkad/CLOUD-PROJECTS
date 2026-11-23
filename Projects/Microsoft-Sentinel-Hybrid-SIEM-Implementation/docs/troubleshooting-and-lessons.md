# Troubleshooting and lessons learned

## Layered troubleshooting model
The project used a structured sequence:

**Network → DNS → Authentication → Service → Data**

Apply it when telemetry fails to arrive:
1. Network: confirm route, VPN, NSG and host firewall connectivity.
2. DNS: confirm forward/reverse resolution and correct domain DNS.
3. Authentication: validate domain join, Kerberos, RBAC and connector permissions.
4. Service: inspect AMA, rsyslog, WinRM, WEC and Azure Arc agent health.
5. Data: confirm DCR association, destination workspace, table, time range and event filters.

## Observations recorded
- AMA extensions reported Succeeded on all configured Windows VMs.
- Heartbeat queries confirmed VM connectivity.
- Entra ID logs were configured through Content Hub; the report notes this was simpler than troubleshooting Diagnostic Settings in the lab.
- Linux local4 test messages appeared in Sentinel after approximately 10–20 minutes.
- The test generator ran at 30-minute intervals.
- Azure Arc onboarding succeeded for LOG-COLLECTOR.
- DC security events were forwarded into the collector's Forwarded Events log.
- Module 3 remained in progress due to permission constraints.
- Module 4 was partially complete.

## Operational lessons
- Plan network routes and permissions before deploying connectors.
- Allow for ingestion latency; verify the expected service and table before changing configuration.
- Record working commands and DCR settings for repeatability.
- Monitor ingestion volume and cost, especially when collecting all Windows security events.
- Use a reusable KQL library and deployment runbook.
- Automate repeatable deployment with reviewed IaC after the manual workflow is validated.
