# Deployment runbook

> Use a disposable Azure lab. Review target subscription, resource group, VNet, subnet and resource names. Confirm current Azure CLI/API behaviour before execution.

## 1. Enable Defender for Servers Plan 2
1. Azure portal → Microsoft Defender for Cloud → Environment settings.
2. Select the subscription and onboard it if necessary.
3. Under Defender plans, enable Servers and select Plan 2.
4. Save and verify.

~~~bash
az security pricing create --name VirtualMachines --tier Standard --subplan P2
az security pricing show --name VirtualMachines --output table
~~~

Expected: tier Standard, subplan P2. Allow time for dependent recommendations and eligible-resource lists to update.

## 2. Configure JIT RDP on VM1
1. Defender for Cloud → Workload protections → Just-in-time VM access.
2. Open Not configured, select VM1, choose Enable JIT on 1 VM.
3. Edit RDP TCP 3389 and set Max request time to 1 hour.
4. Save; verify VM1 appears under Configured with port 3389 and a one-hour maximum.
5. Do not use Request access while configuring the policy; that action opens a temporary access window.

If VM1 is absent, check Defender for Servers Plan 2 and propagation, the Unsupported tab, VM state and NSG prerequisites. The source lab observed VM1 becoming available after plan propagation.

## 3. Deploy Guest Configuration extension
For a Windows VM:

~~~bash
az vm identity assign --resource-group RG1 --name <vm-name>
az vm extension set --resource-group RG1 --vm-name <vm-name> \
  --publisher Microsoft.GuestConfiguration \
  --name ConfigurationforWindows --enable-auto-upgrade true
az vm extension list --resource-group RG1 --vm-name <vm-name> --output table
~~~

The source lab used ConfigurationForLinux for Linux. Confirm current supported extension names and prerequisites. Repeat for every in-scope VM and retain deployment evidence. Also verify the Defender recommendation and machine-configuration assessment; extension installation alone does not prove compliance.

## 4. Restrict Key Vault network access
1. Enable Microsoft.KeyVault service endpoint on Subnet1-1.
2. Add Subnet1-1 to the vault's selected virtual networks.
3. Set default network action to Deny.
4. Test allowed and denied network paths.

~~~bash
az network vnet subnet update --resource-group RG1 --vnet-name <vnet-name> \
  --name Subnet1-1 --service-endpoints Microsoft.KeyVault
az keyvault network-rule add --name <key-vault-name> --resource-group RG1 \
  --vnet-name <vnet-name> --subnet Subnet1-1
az keyvault update --name <key-vault-name> --resource-group RG1 --default-action Deny
~~~

Network rules do not replace Key Vault data-plane RBAC/access policies. Validate network reachability and identity permissions independently.

## 5. Enable Key Vault purge protection

~~~bash
az keyvault update --name <key-vault-name> --resource-group RG1 --enable-purge-protection true
~~~

Verify in Key Vault Properties. Purge protection cannot be disabled once enabled; confirm retention and recovery requirements first.

## 6. Create Azure SQL private endpoint

~~~bash
SQL_ID=$(az sql server show --resource-group RG1 --name <sql-server-name> --query id --output tsv)
az network private-endpoint create --resource-group RG1 \
  --name <private-endpoint-name> --vnet-name <vnet-name> --subnet Subnet1-1 \
  --private-connection-resource-id "$SQL_ID" --group-id sqlServer \
  --connection-name <connection-name>
az network private-endpoint-connection list --id "$SQL_ID" --output table
~~~

Verify connection state is Approved. Configure and validate the appropriate private DNS zone and VNet link, then test resolution from an intended client. Creating the endpoint alone does not prove traffic uses the private path.

## 7. Final validation
Use validation-matrix.md. Record plan state, JIT configuration, extension status for every VM, Key Vault network rules and purge protection, SQL endpoint approval, DNS resolution and allowed/denied access tests.
