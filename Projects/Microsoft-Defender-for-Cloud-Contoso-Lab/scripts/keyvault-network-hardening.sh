#!/usr/bin/env bash
# Restrict Key Vault network path to a selected subnet.
# Confirm resource names and impact before applying; default Deny can interrupt workloads.
set -euo pipefail
RG="RG1"
VNET="<vnet-name>"
SUBNET="Subnet1-1"
VAULT="<key-vault-name>"
az network vnet subnet update --resource-group "$RG" --vnet-name "$VNET" \
  --name "$SUBNET" --service-endpoints Microsoft.KeyVault
az keyvault network-rule add --name "$VAULT" --resource-group "$RG" \
  --vnet-name "$VNET" --subnet "$SUBNET"
az keyvault update --name "$VAULT" --resource-group "$RG" --default-action Deny
az keyvault show --name "$VAULT" --resource-group "$RG" --output json
