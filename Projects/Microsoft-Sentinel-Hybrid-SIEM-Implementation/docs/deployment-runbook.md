# Deployment runbook

This runbook reconstructs the completed Sentinel and Linux implementation from the project report. Portal labels and product prerequisites can change; verify the current Microsoft documentation and tenant permissions before execution.

## 1. Prerequisites
- Active Azure subscription.
- Appropriate permissions to create Log Analytics workspaces, enable Microsoft Sentinel, configure data connectors and deploy monitoring agents.
- Resource group and network plan.
- Windows and Linux test endpoints.
- A dedicated lab tenant/subscription; do not use production endpoints for attack simulations.

## 2. Create the Log Analytics workspace
1. In Azure Portal, open Log Analytics workspaces.
2. Create the workspace named SentinelLAW-Honesty.
3. Select resource group DCR and region East US 2.
4. Use the Pay-as-you-go pricing tier recorded in the source lab.
5. Record the workspace resource ID and verify deployment.

## 3. Enable Microsoft Sentinel
1. Open Microsoft Sentinel in Azure Portal.
2. Select Add and choose the existing SentinelLAW-Honesty workspace.
3. Wait for deployment to complete.
4. Open the workspace and confirm Sentinel dashboards and configuration are available.

## 4. Configure data connectors
The source report records successful integration of:
- Microsoft Entra ID.
- Microsoft Defender for Cloud.
- Azure Network Security Groups.

For each connector, confirm the required diagnostic settings, permissions, destination workspace and expected tables. Do not assume that enabling a connector proves data ingestion; validate by querying the target table.

## 5. Deploy AMA and configure the Windows DCR
1. Create the Data Collection Rule named DCR-WindowsSecurityEvents-01.
2. Configure the Windows Security Events data source to collect All Security Events, as recorded in the lab.
3. Associate the DCR with the Domain Controller, EP1-VM and EP2-VM.
4. Confirm the Azure Monitor Windows Agent extension reports Succeeded on each VM.
5. Query Heartbeat and SecurityEvent to verify telemetry.

**Production note:** All Security Events can generate high ingestion volume and cost. Use a defined event selection policy (for example, a supported Common or Custom profile) aligned to detection requirements and retention.

## 6. Onboard Ubuntu Linux
1. Deploy Ubuntu VM EP3-VM-Linux.
2. Install required packages recorded in the lab: rsyslog, sssd and realmd.
3. Configure DNS and Kerberos to use the Domain Controller.
4. Join the Honesty.com domain using the approved realm join workflow.
5. Configure rsyslog to route local4 facility messages to a dedicated log file.
6. Install and connect AMA.
7. Configure Syslog via AMA and collect the required facility/severity.
8. Create a systemd service/timer or equivalent managed mechanism to generate benign test messages every 30 minutes.
9. Query the Syslog table and verify the custom messages arrive.

The source report observed a 10–20 minute ingestion delay and verified the 30-minute message cadence.

## 7. Verify ingestion
Use the queries in `../queries/sentinel-validation.kql`. Confirm time range, workspace, endpoint identity and expected event fields before treating the data source as operational.
