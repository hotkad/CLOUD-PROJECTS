# GUI Implementation Guide

This runbook follows the assessment order and uses Windows Server GUI consoles. Use a lab domain and an account with the privileges required for each operation. Exact wizard labels can vary slightly by Windows Server release.

## Pre-flight checks

1. Confirm DC1 is a healthy, writable domain controller for `contoso.com`.
2. Confirm DC2 has a supported Windows Server installation, a static address in `172.16.1.0/24`, correct DNS pointing to the existing AD DNS service, and network connectivity to DC1.
3. Sign in with delegated administrative credentials. Enterprise Admin privileges are required for enabling the forest-wide Recycle Bin; appropriate domain privileges are required for domain changes and FSMO transfer.
4. Do not record passwords in screenshots, notes, or this repository.

## Task 1 — Paris site, subnet, DC2 promotion, RID Master

### A. Create the Paris site on DC1

1. Open **Server Manager → Tools → Active Directory Sites and Services**.
2. Expand **Sites**.
3. Right-click **Sites → New Site**.
4. Name the site `Paris`.
5. Select the existing site link (normally `DEFAULTIPSITELINK`) and click **OK**.
6. Acknowledge the informational message.

### B. Associate the subnet

1. In Active Directory Sites and Services, right-click **Subnets → New Subnet**.
2. Enter `172.16.1.0/24`.
3. Select **Paris** as the site.
4. Click **OK**.
5. Verify the subnet object appears and is associated with Paris.

### C. Install AD DS on DC2

1. Sign in to DC2.
2. Open **Server Manager → Manage → Add Roles and Features**.
3. Choose **Role-based or feature-based installation**.
4. Select DC2 as the destination.
5. Select **Active Directory Domain Services** and accept **Add Features** when prompted.
6. Continue through the wizard and select **Install**.
7. Wait for installation to complete.

### D. Promote DC2

1. In Server Manager, select the notification flag and **Promote this server to a domain controller**.
2. Choose **Add a domain controller to an existing domain**.
3. Enter `contoso.com` and provide authorized domain credentials.
4. On **Domain Controller Options**, keep DNS Server and Global Catalog selected unless the lab has a documented reason not to; leave Read Only Domain Controller unselected.
5. Select **Paris** as the site.
6. Enter the DSRM password supplied in the assessment. Do not put it in this repository or screenshots.
7. Use the existing DNS/delegation defaults unless the wizard reports a real prerequisite issue.
8. Select DC1 as replication source if the wizard asks.
9. Leave database, log, and SYSVOL paths at their defaults.
10. Review options, run prerequisite checks, then select **Install**.
11. Allow DC2 to restart.

### E. Verify DC2 and transfer only RID Master

1. On DC2, open **Active Directory Users and Computers** and confirm DC2 is present in the **Domain Controllers** OU.
2. Open **Active Directory Sites and Services → Sites → Paris → Servers** and confirm DC2 is listed under Paris.
3. Allow replication to complete and investigate any DNS, connectivity, or replication errors before transferring the role.
4. In ADUC, right-click the domain name `contoso.com` → **Operations Masters**.
5. Select the **RID** tab. Confirm the current role holder.
6. Select **Change** and confirm the transfer to DC2.
7. Reopen the RID tab and verify DC2 is displayed as the role holder.
8. Do not transfer or seize the other FSMO roles.

## Task 2 — Paris OU, contractor, group, protected-account flag, delegation

### A. Create the OU

1. Open **Server Manager → Tools → Active Directory Users and Computers**.
2. Right-click the `contoso.com` domain → **New → Organizational Unit**.
3. Name it `Paris`.
4. Leave **Protect container from accidental deletion** checked.
5. Select **OK**.

### B. Create ParisContractor

1. Right-click the Paris OU → **New → User**.
2. Set the logon name to `ParisContractor` (the display/full name can also be ParisContractor).
3. Complete the wizard using an approved initial password; do not publish it.
4. Open the new user’s **Properties → Account** tab.
5. Under **Account expires**, select **End of** and set **December 31, 2027**.
6. Apply the change.

### C. Configure the protected-account setting

The phrase **protected account** in this ADUC task refers to the user-account flag **Account is sensitive and cannot be delegated**. It is not the same as membership in the Protected Users group.

1. Open **ParisContractor → Properties → Account**.
2. Under **Account options**, select **Account is sensitive and cannot be delegated**.
3. Select **Apply → OK**.
4. Verify the checkbox remains selected.

Do not add the account to the Protected Users group unless there is a separate requirement to do so. That group has broader authentication effects and is not a substitute for the requested account flag.

### D. Create Paris Admins

1. Right-click Paris OU → **New → Group**.
2. Group name: `Paris Admins`.
3. Group scope: **Universal**.
4. Group type: **Security**.
5. Select **OK**.

### E. Add the contractor to the group

1. Open Paris Admins properties → **Members → Add**.
2. Enter `ParisContractor`, select **Check Names**, then **OK**.
3. Apply and close.
4. Verify ParisContractor appears in the Members list.

### F. Delegate password-reset management at Paris OU scope

1. Right-click the **Paris OU** → **Delegate Control**.
2. Select **Next → Add**.
3. Enter `Paris Admins`, select **Check Names**, then **OK**.
4. Select **Next**.
5. Select only **Reset user passwords and force password change at next logon**.
6. Select **Next → Finish**.
7. Inspect **Paris OU → Properties → Security → Advanced** to review the delegated entry and scope. Do not grant domain-wide permissions or unrelated object-management rights.

The wizard's standard task is the least-effort built-in delegation for password resets. Verify the resulting permissions and inheritance scope rather than assuming a display label alone proves least privilege.

## Task 3 — Find and move users whose City is Paris

### A. Find matching user accounts

1. In ADUC, right-click the domain → **Find**.
2. Choose **Users, Contacts, and Groups**.
3. Open **Advanced → Field → User → City**.
4. Set condition to **Is** and value to `Paris`.
5. Select **Add → Find Now**.
6. Review the returned objects. Select only user accounts matching the City attribute; do not select contacts or groups.

### B. Move matching users

1. Select the matching user accounts in the results.
2. Right-click → **Move**.
3. Select the Paris OU and confirm.

### C. Disable and flag each moved account

1. In the Paris OU, select the moved accounts and choose **Disable Account**.
2. For each moved account, open **Properties → Account**.
3. Select **User must change password at next logon**.
4. Apply and close.
5. Verify the account is disabled and the password-change flag is set.

These are separate attributes. A disabled account cannot log on to change its password until it is re-enabled; do not re-enable it unless instructed.

## Task 4 — Domain password policy, FGPP, Recycle Bin

### A. Domain minimum password length = 12

1. Open **Server Manager → Tools → Group Policy Management**.
2. Expand **Forest → Domains → contoso.com**.
3. Right-click **Default Domain Policy → Edit**.
4. Navigate to **Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Password Policy**.
5. Open **Minimum password length**.
6. Select **Define this policy setting**, enter `12`, then **Apply → OK**.
7. Do not change unrelated password policy settings.

### B. Fine-grained policy for Domain Admins = 16

1. Open **Server Manager → Tools → Active Directory Administrative Center**.
2. Navigate to the domain → **System → Password Settings Container**.
3. Select **New → Password Settings**.
4. Give the policy a clear name, e.g. `Domain Admins Password Policy`.
5. Set **Precedence** to `1`.
6. Set **Minimum password length** to `16`.
7. Keep other settings at their defaults unless the wizard requires otherwise.
8. Under **Directly applies to**, select **Add**, enter `Domain Admins`, and validate the name.
9. Save and reopen the policy to verify the values and target.

FGPP applies to users and global security groups, not OUs or universal groups. Domain Admins is the appropriate global security group target. If multiple FGPPs can apply, review precedence and resultant policy.

### C. Enable Active Directory Recycle Bin

1. In ADAC, select the forest/domain navigation node.
2. Locate **Enable Recycle Bin** in the Tasks pane (location can vary with the ADAC view).
3. Confirm the forest functional-level prerequisites and that you have the required Enterprise Admin rights.
4. Select **Enable Recycle Bin** and confirm the irreversible forest-wide operation.
5. Wait for replication.
6. Refresh ADAC and verify the Deleted Objects container is available.

Do not attempt to disable the Recycle Bin after enabling it; enablement is irreversible.

## Task 5 — NTLM policy and GPO1

### A. Default Domain Controllers Policy — domain NTLM restriction

1. Open **Group Policy Management**.
2. Expand **Domains → contoso.com → Domain Controllers**.
3. Right-click **Default Domain Controllers Policy → Edit**.
4. Navigate to **Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → Security Options**.
5. Locate the exact setting **Network security: Restrict NTLM: NTLM authentication in this domain**.
6. Open the setting and inspect the options available in the target server version.
7. Select the option that denies all NTLM authentication to the domain, as explicitly required by the assessment. Windows versions may label the deny modes differently; do not substitute a similarly named Incoming NTLM traffic or Outgoing NTLM traffic policy.
8. Apply the setting and record the exact selected label in the evidence log.

**Do not guess based on an option that merely says Enable or Disable.** If the expected deny option is not present, capture the full policy name and dropdown in a screenshot and verify the OS/policy template version before changing anything. This setting is security-impacting and may break legacy dependencies.

### B. Create and link GPO1 to Paris OU

1. In GPMC, right-click the **Paris OU**.
2. Select **Create a GPO in this domain, and Link it here**.
3. Name it `GPO1` and confirm.
4. Select the Paris OU and verify GPO1 appears in **Linked Group Policy Objects** with **Link Enabled = Yes**.
5. Leave default security filtering unchanged unless the task explicitly requires otherwise.

### C. Audit unsuccessful logon events

1. Right-click GPO1 → **Edit**.
2. Navigate to **Computer Configuration → Policies → Windows Settings → Security Settings → Advanced Audit Policy Configuration → System Audit Policies → Logon/Logoff**.
3. Open **Audit Logon**.
4. Select **Configure the following audit events**.
5. Enable **Failure** only; leave Success unselected.
6. Apply and close.

### D. Deny Paris Admins the service logon right

1. In GPO1 editor, navigate to **Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → User Rights Assignment**.
2. Open **Deny log on as a service**.
3. Select **Define these policy settings**.
4. Choose **Add User or Group**.
5. Enter `Paris Admins`, select **Check Names**, then **OK**.
6. Apply and close.
7. Preserve existing entries in the user-rights assignment list.

### E. Verify scope

1. Return to GPMC and select Paris OU.
2. Confirm GPO1 is linked and enabled.
3. Confirm it has not been linked at the domain root or another OU.
4. Remember these are computer configuration settings: they process on computer accounts in the Paris OU or its descendants. A user being in Paris OU does not by itself cause the computer-side settings to apply to that user's workstation.

## Post-change checks

Use [VALIDATION.md](VALIDATION.md) to record the observed state. Allow AD replication and Group Policy processing to complete. In production, test NTLM restrictions and user-rights changes against application and service dependencies before broad enforcement.
