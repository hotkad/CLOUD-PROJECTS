# Troubleshooting and lessons learned

## VM1 absent from JIT eligible resources
**Symptom:** VM1 did not appear in the Not configured list on the first attempt.

**Diagnosis/action:** Defender for Servers Plan 2 had only just been enabled. The lab allowed propagation time and checked the Unsupported tab and VM NSG. VM1 was subsequently configured from the JIT blade.

**Lesson:** Enable prerequisite plans first, allow service state to propagate, then troubleshoot resource eligibility.

## Guest Configuration extension absent from portal gallery
**Symptom:** The Add extension gallery did not list the extension and the related Defender recommendation had not populated.

**Action:** Azure CLI was used to assign a managed identity and deploy Microsoft.GuestConfiguration to VM1. The extension reported provisioning state Succeeded.

**Remaining issue:** The assessment's posture/vulnerability-management check still failed. The source report hypothesised that the grader was evaluating Defender plan settings and vulnerability assessment rather than the manual extension alone. This was not conclusively resolved.

**Lesson:** Prefer the Defender-native recommendation Fix workflow or plan configuration where applicable. Verify the Defender recommendation itself, not just VM extension status.

## Configuration versus assessment state
Keep separate evidence for resource configuration, extension provisioning, Defender recommendation state, machine-configuration compliance and vulnerability assessment status. Some assessments update asynchronously.

## Least-change approach
Defender CSPM and unrelated plans were left disabled because no requirement called for them. This reduced unnecessary scope, licensing exposure and administrative changes.

## Final verification
The SQL private endpoint connection state was rechecked before submission. Verify every requirement at the end, including resources configured earlier.
