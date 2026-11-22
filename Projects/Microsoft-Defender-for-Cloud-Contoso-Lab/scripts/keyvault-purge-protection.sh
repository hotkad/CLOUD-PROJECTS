#!/usr/bin/env bash
# CAUTION: Purge protection cannot be disabled once enabled.
set -euo pipefail
RG="RG1"
VAULT="<key-vault-name>"
az keyvault update --name "$VAULT" --resource-group "$RG" --enable-purge-protection true
az keyvault show --name "$VAULT" --resource-group "$RG" \
  --query "{name:name,enablePurgeProtection:properties.enablePurgeProtection,softDeleteRetentionInDays:properties.softDeleteRetentionInDays}" \
  --output table
