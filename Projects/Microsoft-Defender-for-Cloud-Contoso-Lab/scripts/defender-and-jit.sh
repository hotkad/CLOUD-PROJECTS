#!/usr/bin/env bash
# Azure CLI reference: Defender for Servers Plan 2 and verification.
# Review subscription context and pricing before running.
set -euo pipefail
az account show --output table
az security pricing create --name VirtualMachines --tier Standard --subplan P2
az security pricing show --name VirtualMachines --output table

# JIT policy is configured in Defender for Cloud portal in this lab:
# Workload protections > Just-in-time VM access > VM1 > TCP/3389 > max 1 hour.
