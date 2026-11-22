#!/usr/bin/env bash
# Deploy Guest Configuration extension to a Windows Azure VM.
# Repeat for every in-scope VM and validate Defender recommendation state separately.
set -euo pipefail
RG="RG1"
VM_NAME="<vm-name>"
az vm identity assign --resource-group "$RG" --name "$VM_NAME"
az vm extension set --resource-group "$RG" --vm-name "$VM_NAME" \
  --publisher Microsoft.GuestConfiguration \
  --name ConfigurationforWindows --enable-auto-upgrade true
az vm extension list --resource-group "$RG" --vm-name "$VM_NAME" --output table
