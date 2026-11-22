# Access-control model

## Control layers

| Layer | Question | Lab implementation |
|---|---|---|
| Authentication | Who signed in? | Microsoft Entra ID |
| Application authorisation | Is the identity assigned to this app? | Enterprise Application assignment required |
| Conditional Access | Under what conditions is access allowed? | Application-targeted CA and GSA signalling |
| Traffic steering | Does traffic traverse the intended service? | GSA client and Private Access forwarding profile |
| Private reachability | Can the connector reach the backend? | Connector group, routing and firewall |
| Device trust | Is the endpoint managed/compliant? | Join posture in lab; compliance is a production recommendation |

These layers are complementary. Application assignment is not a network firewall, and device compliance does not grant access to every application.

## Application assignment
For each Private Access Enterprise Application:
1. Set Assignment required to Yes.
2. Assign the authorised user or, preferably at scale, a governed security group.
3. Remove unintended default/broad group assignments.
4. Keep the negative-control identity unassigned.
5. Verify effective assignment and group membership before interpreting test results.

Expected negative result: an authenticated user without effective assignment is blocked at the application sign-in stage. The lab recorded AADSTS50105 in this case.

## Conditional Access signalling
The lab enabled Conditional Access signalling for Microsoft Entra ID in Global Secure Access session/adaptive access settings. This provides Entra policy evaluation with relevant GSA source-network context for supported traffic.

The project observed propagation taking approximately 20 minutes after changing the setting. This is a lab observation, not a guaranteed service-level duration.

Private Access applications were governed using application-targeted Conditional Access. Do not assume Universal Conditional Access covers every GSA traffic profile; verify current Microsoft product documentation.

## Negative-control design
CLIENT03 is intentionally unassigned. Do not reuse one identity for allow and deny tests: stale sessions, overlapping assignments, token state and device context can contaminate results.

## Production extensions
- Require compliant device where supported and appropriate.
- Use risk-aware Conditional Access, strong MFA, session controls and documented emergency-access exclusions.
- Replace manual individual assignments with governed groups, access packages, approvals and periodic access reviews.
- Monitor sign-in, audit, traffic and connector health.
- Validate all alternate routes; GSA cannot enforce policy on traffic that bypasses its data plane.
