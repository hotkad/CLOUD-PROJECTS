# Microsoft Entra Global Secure Access (GSA) — Zero Trust Private Access Lab

A documented, evidence-led lab demonstrating identity-centric access to private enterprise applications using Microsoft Entra Private Access, Global Secure Access (GSA), the Private Network Connector, Entra ID application assignment, Conditional Access signalling, private DNS, and Azure network segmentation.

> Portfolio project: a cleaned, sanitised engineering presentation of a completed lab. It uses a fictional organisation (LabCorp), synthetic identities, and RFC1918 addressing. No tenant credentials, customer data, production exports, or secrets are included.

## Executive summary

The lab models a hybrid organisation moving away from network-location trust toward per-application Zero Trust access. It deliberately compares three endpoint postures:

- **CLIENT01 — legacy / hybrid-joined baseline:** domain joined and network peered. Demonstrates why network reachability can bypass identity-aware access controls.
- **CLIENT02 — authorised Zero Trust endpoint:** Entra joined, isolated from the application VNet, and dependent on the GSA Private Access path. Its test identity is assigned to the published applications.
- **CLIENT03 — unauthorised negative-control endpoint:** Entra joined and similarly isolated, but its test identity is deliberately not assigned. It validates denial for an authenticated but unauthorised user.

The environment includes DC01 (AD DS and DNS), CONN01 (Private Network Connector), APP01 (IIS application host), three internal web portals, and segmented client endpoints.

## Outcomes demonstrated

- Published internal AD/management and IIS resources through Entra Private Access without requiring inbound connector exposure.
- Configured application segments using explicit destination, protocol, and port definitions.
- Routed the private labcorp.local DNS namespace through the Private Access path.
- Used Enterprise Application Assignment required and explicit user assignment as the primary authorisation control.
- Enabled Conditional Access signalling for Entra ID.
- Isolated the legacy endpoint with a NIC-scoped Network Security Group (NSG) to remove an alternate path to APP01.
- Documented ten implementation blockers across Conditional Access, hybrid join, client deployment, RPC, application assignment, network bypass, tenant alignment, private DNS, RDP authentication, and test identity design.

## Architecture

~~~mermaid
flowchart LR
  subgraph Entra["Microsoft Entra tenant"]
    ID["Microsoft Entra ID"]
    GSA["Global Secure Access"]
    PA["Entra Private Access"]
    CA["Conditional Access"]
    APPS["Enterprise Applications"]
    ID --- GSA
    GSA --- PA
    ID --- CA
    ID --- APPS
  end
  subgraph Azure["Azure lab network"]
    DC["DC01: AD DS + DNS\n172.16.0.5"]
    CONN["CONN01: Private Network Connector"]
    APP["APP01: IIS portals\n172.16.0.10"]
    DC --- APP
    CONN --> DC
    CONN --> APP
  end
  C1["CLIENT01: hybrid joined"]
  C2["CLIENT02: Entra joined, authorised"]
  C3["CLIENT03: Entra joined, unassigned"]
  C2 -->|"GSA tunnel"| GSA
  C3 -->|"GSA tunnel"| GSA
  GSA --> PA
  PA --> CONN
  C1 -. "Direct routed path; not GSA-enforced" .-> DC
  C1 -. "Blocked by NIC NSG" .-> APP
  CA --> APPS
~~~

## Repository guide

| Path | Purpose |
|---|---|
| docs/architecture.md | Components, trust boundaries, identity and traffic flow |
| docs/deployment-runbook.md | Reproducible build sequence and configuration checklist |
| docs/access-control-model.md | Application assignment, Conditional Access and negative testing |
| docs/troubleshooting-and-lessons.md | Ten blockers, diagnosis, resolution and lessons |
| docs/validation-matrix.md | Test cases, expected outcomes and evidence commands |
| docs/enterprise-recommendations.md | Production hardening, resilience and migration strategy |
| scripts/ | Sanitised PowerShell and Azure CLI examples |
| config/ | Lab inventory and port reference |

## Lab inventory

| Component | Role | Address / placement |
|---|---|---|
| DC01 | AD DS, DNS, Entra Connect | 172.16.0.5 |
| CONN01 | Private Network Connector | Internal, peered subnet |
| APP01 | Three IIS-hosted test portals | 172.16.0.10 |
| CLIENT01 | Domain/hybrid-joined legacy endpoint | Peered network |
| CLIENT02 | Entra-joined authorised endpoint | Isolated subnet |
| CLIENT03 | Entra-joined negative-control endpoint | Isolated subnet |

Domain: labcorp.local (synthetic). Cloud tenant identifiers and user principal names have been removed.

## Principal engineering finding

**Entra application assignment only governs traffic that actually traverses the Entra/GSA data plane.** A device with an independent route to a private resource can bypass that identity-plane control. The lab makes this visible by comparing CLIENT01 with CLIENT02 and CLIENT03, then removing CLIENT01's direct route to APP01 using a NIC-scoped NSG.

Network reachability, user authentication, application authorisation, and device posture are separate controls. They must be designed and validated together.

## Reproduce the lab

Start with docs/deployment-runbook.md. Scripts are reference implementations and require review for your subscription, tenant, region, naming standards, and current Microsoft product requirements. Do not execute them unchanged in production.

## Security and scope

- All identities, domains, hostnames, and workloads are synthetic.
- IP addresses are lab-only RFC1918 examples.
- Do not commit tenant IDs, app IDs, client secrets, certificates, access tokens, real user data, or screenshots exposing tenant details.
- Product behaviour and portal navigation evolve; validate current requirements against Microsoft Learn.
- A single connector was used in the lab; this is not a production availability design.
- The lab demonstrates selected access controls, not full enterprise Zero Trust maturity.

## Author

Cloud Security Engineering Portfolio — Microsoft Entra ID, Zero Trust Network Access, Global Secure Access, Azure networking, identity governance, endpoint onboarding, troubleshooting, and PowerShell/Azure CLI automation.
