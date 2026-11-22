# Incident analysis

## Observed incident
The controlled simulation generated an incident named Empire in the recorded run, with three alerts and an attack graph rooted at AttackScript.ps1.

The Evidence tab identified:
- powershell.exe as the injecting process.
- notepad.exe as the target process for process injection/process hollowing.
- An outbound public IP associated with the injected process. The address is deliberately not reproduced because it is dynamic and run-specific.

The source notes 204.79.197.203 as Microsoft background traffic and explicitly identifies it as benign in that run. It is not an IOC and is excluded from the indicator configuration.

## Triage approach
1. Start with the incident Evidence tab and attack graph.
2. Trace process ancestry and identify initiating and target processes.
3. Correlate network events with the injected process.
4. Review the endpoint timeline around the incident time.
5. Filter routine driver activity, service-host activity and browser update traffic rather than treating all endpoint events as malicious.
6. Extract the actual malicious address from current incident evidence and validate it before creating a block indicator.

## IOC handling
Indicator1 was configured with:
- Type: IP address
- Action: Block execution
- Alert generation: Enabled
- Severity: High
- Category: Execution
- Scope: All devices in the lab organisation

The exact IP is intentionally omitted from this public repository. In production, indicators require confidence assessment, expiry/review, threat-intelligence context and change control. Broad organisation-wide blocking should not be based on an unverified observation.

## Device naming caveat
The source report's task heading references Client1 for investigation, but the simulation and later forensic response refer to Client2. Confirm endpoint identity from the incident/device ID in the tenant before using this workflow operationally.
