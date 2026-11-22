# Detection engineering

## Custom hunting query

The lab's custom detection searches for PowerShell initiating Notepad, matching the process-injection pattern observed in the simulation.

~~~kql
DeviceProcessEvents
| where InitiatingProcessFileName =~ "powershell.exe"
| where FileName =~ "notepad.exe"
| project
    Timestamp,
    DeviceId,
    ReportId,
    DeviceName,
    InitiatingProcessAccountName,
    InitiatingProcessAccountObjectId
~~~

This query is preserved as a starting point, not a production-ready analytic. It is narrow and may generate false positives in environments where PowerShell legitimately launches Notepad.

## Rule configuration recorded in the lab

| Setting | Value |
|---|---|
| Name | SuspiciousPowershell |
| Frequency | Every hour |
| Scope | All devices |
| Device entity | DeviceId |
| User entity | InitiatingProcessAccountObjectId |
| Device action | Collect investigation package |
| User action | Mark user as compromised |

## Production tuning recommendations
- Add process command-line, parent process, signer/hash and device context where available.
- Consider expected administrative scripts and software deployment tools.
- Use allowlisting only for well-understood, signed and controlled activity.
- Validate entity mappings against the current Advanced Hunting schema and custom detection requirements.
- Test alert volume and false positives before enabling automated response actions.
- Review rule frequency, lookback window, licensing and supported response actions.
- Version-control query changes and document rationale.

References:
- [DeviceProcessEvents table](https://learn.microsoft.com/defender-xdr/advanced-hunting-deviceprocessevents-table)
- [Create custom detection rules](https://learn.microsoft.com/defender-xdr/custom-detection-rules)
