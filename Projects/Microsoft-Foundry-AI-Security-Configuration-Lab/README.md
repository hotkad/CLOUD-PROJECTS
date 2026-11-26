# Microsoft Foundry AI Security Configuration Lab

## Project status

**Status:** In progress — assessment configuration and validation are not yet fully complete.

This project documents a hands-on Microsoft Foundry security configuration exercise focused on securing an AI application and its supporting Azure services. The work is maintained as a standalone project and is not part of the Microsoft Entra Global Secure Access (GSA) implementation.

## Objectives

Configure cloud security posture management, workload protection, access control, diagnostic logging, secure storage connectivity, and AI safety guardrails for a Microsoft Foundry solution.

## Environment

The assessment supplied an existing Azure environment containing:

- A Microsoft Foundry resource and project
- An Azure Log Analytics workspace
- An Azure Storage account
- A resource group containing the supplied resources

**Security note:** Assessment-specific usernames, temporary access credentials, tenant identifiers, and resource-instance identifiers are intentionally excluded from this public portfolio documentation.

## Scope and intended implementation

### 1. Cloud security posture management

Intended configuration in Microsoft Defender for Cloud:

- Enable Defender CSPM.
- Enable the AI Services workload protection plan.
- Enable data security for AI interactions.
- Enable workload protection for Azure Storage.
- Enable workload protection for Azure Key Vault.

Plan configuration is subscription-scoped in Defender for Cloud. Availability and successful enablement depend on the assessment identity having the required subscription permissions. Record the actual portal state and any authorization errors before marking this section complete.

### 2. Foundry resource access control

Intended configuration:

- Assign the appropriate Foundry project-development role to the designated developer security group at the Foundry resource scope.
- Verify the role assignment in Azure Access control (IAM).

Record the exact role presented and selected in the assessment portal. Do not claim successful assignment until it is visible in Role assignments.

### 3. Diagnostic logging

Intended configuration:

- Create a diagnostic setting on the Microsoft Foundry resource.
- Route the Request and Response Logs category to the supplied Log Analytics workspace.
- Verify the saved diagnostic setting and, where possible, confirm that events are ingested.

Example validation query (table/category availability depends on the diagnostic destination and resource configuration):

```kusto
AzureDiagnostics
| where TimeGenerated > ago(24h)
| sort by TimeGenerated desc
```

### 4. Storage connection

Intended configuration in the **New Microsoft Foundry** experience:

- Open the target project.
- Add the existing Azure Storage connection.
- Select Microsoft Entra ID authentication.
- Do not configure storage data-plane permissions unless explicitly required by the task.

A saved connection is not proof that the project can read or write data; access permissions must be validated separately when they become in scope.

### 5. AI safety guardrails / content filtering

Required policy outcomes:

| Control | Required behaviour |
|---|---|
| Indirect prompt attack detection for uploaded content | Detect/annotate the attack while allowing the request to continue |
| Hate | Highest available blocking level |
| Self-harm | Highest available blocking level |
| Violence | Highest available blocking level |
| Restricted term | Block the term `ProjectX` in both user prompts and model responses |

The assessment requested a filter named `Filter1` and explicitly did not require applying it to a deployment.

**Outstanding issue:** Creation of the custom blocklist for `ProjectX` failed in the assessment portal. The blocklist has therefore not been recorded as successfully created, and the ProjectX input/output filtering requirement remains unverified. Do not represent this control as implemented until the blocklist is successfully created, attached to the filter, and verified for both input and output.

## Validation and evidence checklist

- [ ] Defender CSPM enabled and verified.
- [ ] AI Services protection enabled.
- [ ] Data security for AI interactions enabled.
- [ ] Storage protection enabled.
- [ ] Key Vault protection enabled.
- [ ] Developer group role assignment visible at the Foundry resource scope.
- [ ] Request and Response Logs routed to the intended Log Analytics workspace.
- [ ] Storage connection visible in the Foundry project and uses Microsoft Entra ID authentication.
- [ ] Indirect prompt attack control configured to annotate rather than block.
- [ ] Hate, self-harm, and violence configured at the highest blocking level.
- [ ] Custom blocklist containing `ProjectX` created successfully.
- [ ] `ProjectX` filtering enabled for both user input and model output.
- [ ] `Filter1` saved and not assigned to a deployment.

## Implementation notes and limitations

- This is a portal-based assessment exercise; no infrastructure-as-code deployment is claimed.
- Defender plan enablement may require subscription-level permissions beyond resource-group access.
- New Foundry guardrail capabilities and custom blocklist workflows must be verified in the actual portal experience. Do not substitute a classic Foundry content-filter workflow without confirming that it satisfies the New Foundry task.
- Keep screenshots as evidence, but redact account names, tenant IDs, subscription IDs, access tokens, temporary access passes, and customer-specific identifiers before publishing.

## Skills demonstrated

- Microsoft Defender for Cloud and CSPM
- AI workload security
- Azure RBAC and least privilege
- Microsoft Foundry administration
- Azure Monitor diagnostic settings
- Log Analytics
- Microsoft Entra ID authentication
- AI safety guardrails and prompt-attack detection
- Security configuration validation and evidence handling

## References

- [Microsoft Defender for Cloud documentation](https://learn.microsoft.com/azure/defender-for-cloud/)
- [Microsoft Foundry documentation](https://learn.microsoft.com/azure/ai-foundry/)
- [Azure Monitor diagnostic settings](https://learn.microsoft.com/azure/azure-monitor/essentials/diagnostic-settings)
- [Azure role-based access control](https://learn.microsoft.com/azure/role-based-access-control/overview)
