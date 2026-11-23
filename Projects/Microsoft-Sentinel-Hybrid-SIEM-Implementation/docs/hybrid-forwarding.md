# Hybrid log forwarding — implementation status

## Design objective
Extend Sentinel monitoring to an on-premises Windows Server 2022 host, LOG-COLLECTOR, deployed in VirtualBox to simulate a hybrid environment.

## Components recorded
- Windows Server 2022 VM renamed LOG-COLLECTOR.
- VPN configured between the simulated on-premises network and Azure VNet.
- Azure Connected Machine Agent installed.
- Server connected to Azure Arc using device-code authentication.
- WinRM and Windows Event Collector services enabled.
- Collector-initiated subscription created to collect selected security events from the Domain Controller.

## Event IDs recorded
The source report lists examples including:
- 4624 — successful logon.
- 4625 — failed logon.
- 4720 — user account created.

## Observed result
The report confirms the Windows security events were forwarded from the Domain Controller to the LOG-COLLECTOR Forwarded Events log. It also confirms the server appeared under Azure Arc Machines.

**Status remains in progress:** The report does not confirm that AMA was installed on LOG-COLLECTOR, that a DCR collected the Forwarded Events channel, or that the events were queried successfully in Sentinel. Therefore, do not describe the full hybrid log-forwarding pipeline as complete.

## Remaining validation steps
1. Confirm LOG-COLLECTOR has stable VPN reachability and DNS resolution to the Domain Controller.
2. Verify WinRM listener, firewall rules and Windows Event Collector service state.
3. Confirm the source-initiated/collector-initiated subscription is active and events arrive in Forwarded Events.
4. Install and verify AMA on LOG-COLLECTOR.
5. Associate the collector with a DCR that collects the Forwarded Events channel.
6. Confirm the expected event IDs appear in the workspace's SecurityEvent table.
7. Correlate a test event by timestamp, host and event record ID.
8. Document RBAC, network ports, certificate/authentication model and operational ownership.

## Security considerations
- Restrict WinRM and event subscription traffic to the required hosts and networks.
- Use least-privilege accounts and hardened service configuration.
- Do not expose WinRM to the public internet.
- Monitor Azure Arc agent health and DCR association state.
- Define buffering, retry and outage recovery expectations.
