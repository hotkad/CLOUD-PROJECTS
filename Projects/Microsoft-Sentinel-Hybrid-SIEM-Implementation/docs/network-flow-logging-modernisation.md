# Azure network flow logging — modernisation note

## Historical lab configuration
The original Sentinel report documents NSG Flow Logs v2 with Traffic Analytics. Preserve this as a historical lab result if the existing data and screenshots support it.

## Current platform constraint
Microsoft no longer supports creating new NSG flow logs after 30 June 2025. NSG flow logs retire on 30 September 2027. Existing resources and historical storage records may continue to exist under the published lifecycle, but a new implementation should not depend on creating NSG flow logs.

## Recommended new design
Use Azure Virtual Network flow logs for new network-flow visibility. Validate the supported Traffic Analytics path, storage destination, workspace integration, retention, and Sentinel ingestion before claiming end-to-end network telemetry.

## Validation checklist
- [ ] VNet flow log resource created for the intended VNet.
- [ ] Storage destination and retention reviewed.
- [ ] Traffic Analytics configuration validated where required.
- [ ] Flow data appears in the expected analytics destination.
- [ ] Sentinel connector/ingestion path and table confirmed.
- [ ] Queries and analytic rules updated for the actual schema.
- [ ] Historical NSG flow log resources are inventoried and migration planned.
- [ ] Disable old NSG flow logs only after VNet flow logging is verified.

References:
- [NSG Flow Logs overview and retirement](https://learn.microsoft.com/azure/network-watcher/network-watcher-nsg-flow-logging-overview)
- [Network monitoring and observability](https://learn.microsoft.com/azure/networking/design-guide/monitor)
- [Migrate to Virtual Network Flow Logs](https://learn.microsoft.com/azure/network-watcher/nsg-flow-logs-migrate)
