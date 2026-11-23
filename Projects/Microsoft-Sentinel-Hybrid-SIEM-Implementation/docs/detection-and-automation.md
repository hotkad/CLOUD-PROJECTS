# Detection and automation

## UEBA
The source report records that User and Entity Behavior Analytics (UEBA) was enabled to establish behavioural baselines across users, hosts and IP addresses. Production use requires sufficient telemetry, suitable licensing/configuration and a review of entity mapping and privacy requirements.

## Failed logon detection
A custom analytic was designed to identify multiple failed logon attempts using Windows Security Event ID 4625. The source report states that simulated failed sign-ins generated an incident and triggered an email notification.

The exact threshold and time window were not preserved in the report. The query below is therefore an illustrative starting point, not a claim that these exact values were deployed.

## Logic App playbook
The report records deployment of the “Send Basic Email” Logic App playbook from Content Hub and attachment to the custom analytics rule. It describes automated email delivery to security personnel when an incident was created.

Before production:
- Restrict recipients and avoid sending sensitive incident data in email.
- Secure Logic App connections and secrets.
- Apply RBAC and audit playbook changes.
- Add error handling, retries and notification failure monitoring.
- Use automation rules and playbook permissions appropriate to the tenant.

## Validation
The report states that failed sign-in simulation verified incident creation and email delivery. Retain incident IDs and action logs privately as evidence; redact them before publishing.
