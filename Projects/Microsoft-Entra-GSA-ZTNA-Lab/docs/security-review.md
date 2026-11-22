# Public release security review

## Sanitisation
- Reframed the source as a neutral technical portfolio project using fictional LabCorp naming.
- Removed tenant-specific domain suffixes, cloud UPNs, application IDs, request IDs, correlation IDs and timestamps from reproduced examples.
- Did not publish the original 75-page PDF or its embedded portal screenshots.
- Used synthetic hostnames and RFC1918 lab addresses.
- Converted scripts into reviewable examples with placeholders and runtime prompts where secrets might otherwise be required.

## Review before publishing further evidence
- Inspect screenshots for tenant name/ID, subscription ID, UPN, resource ID, public IP, request/correlation ID and browser profile data.
- Rotate credentials that may have appeared in screenshots, terminal history or private documents.
- Ensure no production bank/client names, endpoint names, domains or log fragments are present.
- Confirm permission to publish any employer-owned diagrams, logos or proprietary implementation details. The original employer logo and source PDF are intentionally omitted here.

## Scope
This repository documents a lab implementation and observed results. It is not an official Microsoft reference architecture, production deployment template, or claim that every GSA capability was implemented.
