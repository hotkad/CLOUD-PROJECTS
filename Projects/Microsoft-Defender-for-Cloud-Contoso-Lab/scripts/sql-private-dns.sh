#!/usr/bin/env bash
# Configure the recommended Azure SQL Private DNS zone and VNet link.
# Run after the SQL private endpoint exists. Review DNS topology first.
set -euo pipefail

RG="RG1"
VNET="<vnet-name>"
ZONE="privatelink.database.windows.net"
SQL_SERVER="<sql-server-name>"
PE_NAME="<private-endpoint-name>"
LINK_NAME="<private-dns-vnet-link>"

az network private-dns zone create --resource-group "$RG" --name "$ZONE"
az network private-dns link vnet create --resource-group "$RG" \
  --zone-name "$ZONE" --name "$LINK_NAME" --virtual-network "$VNET" \
  --registration-enabled false

# Associate the existing private endpoint with this private DNS zone.
az network private-endpoint dns-zone-group create \
  --resource-group "$RG" --endpoint-name "$PE_NAME" \
  --name default --private-dns-zone "$ZONE" \
  --zone-name sql

# Validate the SQL FQDN from a client in the linked VNet.
# Use <server>.database.windows.net in SQL connection strings, not the privatelink FQDN.
nslookup "${SQL_SERVER}.database.windows.net"
