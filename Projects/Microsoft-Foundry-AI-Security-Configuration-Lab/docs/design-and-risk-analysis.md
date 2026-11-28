# Microsoft Foundry — Business Requirements, Target Architecture and Threat Model

## Business problem
An organisation is configuring a Microsoft Foundry project and connected Azure resources. The security objective is to reduce risks from excessive developer permissions, exposed data services, insufficient auditability and unsafe model interactions.

## Business requirements
- Enable the specified Defender for Cloud plans and AI/data protection capabilities.
- Assign the required project-development role to the designated developer group at the correct scope.
- Route Foundry request/response diagnostics to the intended Log Analytics workspace.
- Configure the project storage connection to use Microsoft Entra ID authentication.
- Configure indirect prompt-attack handling and content filters for hate, self-harm, violence and the restricted term ProjectX.
- Save Filter1 without attaching it to a deployment, as required by the assessment.

## Target architecture
~~~mermaid
flowchart TB
  DEV["Developer security group"] -->|RBAC at Foundry scope| FOUNDRY["Microsoft Foundry project"]
  FOUNDRY -->|Request / response diagnostics| LAW["Log Analytics workspace"]
  FOUNDRY -->|Entra ID authenticated connection| STORAGE["Azure Storage"]
  FOUNDRY -->|Security posture| DEF["Defender for Cloud"]
  FOUNDRY --> GUARD["Filter1 / AI safety guardrails"]
  GUARD --> PROMPT["Input prompt inspection"]
  GUARD --> RESPONSE["Model response inspection"]
~~~

This is the target design described by the assessment. It is not evidence that every connection or control was successfully deployed.

## Security design decisions
| Decision | Rationale | Trade-off / residual risk |
|---|---|---|
| Group-based RBAC at Foundry resource scope | Avoids direct user grants and supports lifecycle governance | Confirm the exact built-in role and least-privilege scope |
| Entra ID authentication for storage | Avoids long-lived storage keys in the project connection | Data-plane RBAC and network access still need separate validation |
| Request/response diagnostics to Log Analytics | Supports audit, investigation and operational monitoring | Sensitive prompts/responses may be logged; define access, retention and data minimisation |
| Indirect prompt attack annotation | Preserves task-required request flow while surfacing suspicious content | Annotation is not a substitute for tool restrictions, data controls or human review |
| Highest requested content-blocking levels | Reduces exposure to disallowed content categories | False positives and user experience require evaluation |
| Custom ProjectX blocklist | Demonstrates restricted-term input/output control | The source assessment could not create the blocklist; control remains unverified |
| Filter not attached to deployment | Matches the assessment's explicit scope | No runtime enforcement claim can be made |

## Threat model
| Threat | Impact | Control / evidence | Residual risk / next test |
|---|---|---|---|
| Excessive developer permissions | Unauthorised model, project or connection changes | Group-based RBAC at Foundry scope | Verify exact role, inherited assignments and access review |
| Storage key exposure | Data exfiltration or unauthorised access | Entra ID authentication | Confirm managed identity/principal and storage data-plane role; restrict network path |
| Sensitive prompt/response logging | Exposure of personal or confidential content | Diagnostic routing to Log Analytics | Classify logged content, restrict workspace access and set retention |
| Indirect prompt injection | Model follows malicious instructions embedded in uploaded content | Indirect attack detection/annotation setting | Test malicious documents; enforce tool allowlists and data boundaries |
| Harmful model output | User safety and policy breach | Content filters for requested categories | Test each severity level and record expected block behaviour |
| Restricted term bypass | Disallowed data or topic passes through model | ProjectX blocklist for input and output | Blocklist creation failed; do not claim this control is active |
| Public storage exposure | Unauthorised data access | Intended Entra connection | Validate storage firewall, private endpoint, public access and RBAC independently |

## Architecture decision records
- **ADR-01 — Group-based project RBAC:** assign the required role to the designated developer group rather than individual users.
- **ADR-02 — Entra ID storage authentication:** avoid account keys where the supported project connection allows Entra authentication.
- **ADR-03 — Central diagnostics:** send request/response logs to the specified workspace while applying data minimisation and access controls.
- **ADR-04 — Filter configuration versus enforcement:** distinguish a saved filter from a filter attached to a deployment; this assessment does not require deployment attachment.
- **ADR-05 — Honest incomplete control status:** ProjectX blocklist remains pending until successfully created, attached to Filter1 and tested for both input and output.

## Completion gate
The project remains **In progress**. Mark each task verified only after capturing actual portal state and, where possible, a functional test. The ProjectX blocklist is a known blocker and must remain visible in the final project status.
