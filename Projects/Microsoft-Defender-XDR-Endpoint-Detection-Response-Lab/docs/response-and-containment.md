# Response and containment

## Live Response
Live Response was enabled under Settings → Endpoints → General → Advanced features. A session was initiated on Client2 and the connections command was used to inspect active network connections.

## Investigation package
The lab initiated Collect investigation package and waited for completion in Action center history. The source environment did not expose a ZIP download link in the action flyout; exporting the action row produced Forensics Collection Summary.csv, saved to the lab workstation.

This is an environment-specific observation. Production tenants may provide a downloadable investigation package archive. Follow the current portal workflow and preserve chain-of-custody metadata.

## Containment
Client2 was isolated after evidence collection. The isolation action was confirmed with a comment and allowed several minutes to complete.

## Response sequence
1. Validate the incident and affected endpoint.
2. Capture incident evidence and relevant timeline details.
3. Inspect network connections and collect the investigation package.
4. Record action status, timestamps and operator.
5. Isolate the endpoint, unless immediate containment is required to prevent ongoing harm.
6. Confirm isolation state and monitor follow-on activity.
7. Coordinate recovery, reimage/restore decision, credential reset and post-incident review under the organisation's IR plan.

## Evidence handling
Keep original evidence in an access-controlled location. Hash downloaded artifacts, record collection time and collector identity, restrict access and redact tenant/device/user identifiers before publishing derived material. Do not commit forensic packages or raw incident exports to a public repository.
