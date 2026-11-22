#!/usr/bin/env bash
# Create a private endpoint for an Azure SQL logical server.
# Configure private DNS separately and validate name resolution from clients.
set -euo pipefail
RG="RG1"
SQL_SERVER="<sql-server-name>"
VNET="<vnet-name>"
SUBNET="Subnet1-1"
PE_NAME="<private-endpoint-name>"
CONNECTION_NAME="<connection-name>"
SQL_ID=$(az sql server show --resource-group "$RG" --name "$SQL_SERVER" --query id --output tsv)
az network private-endpoint create --resource-group "$RG" --name "$PE_NAME" \
  --vnet-name "$VNET" --subnet "$SUBNET" \
  --private-connection-resource-id "$SQL_ID" --group-id sqlServer \
  --connection-name "$CONNECTION_NAME"
az network private-endpoint-connection list --id "$SQL_ID" --output table
