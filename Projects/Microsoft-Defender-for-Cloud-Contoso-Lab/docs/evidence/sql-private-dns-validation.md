# SQL private endpoint DNS validation

The SQL private endpoint is not considered end-to-end validated solely because its connection state is Approved.

1. Confirm the private endpoint is approved.
2. Confirm the `privatelink.database.windows.net` private DNS zone exists.
3. Confirm the zone is linked to the VNet used by the client.
4. Confirm the endpoint DNS zone group has an A record for the SQL server.
5. From a VM in the linked VNet, resolve `<server>.database.windows.net`.
6. Confirm the normal SQL FQDN resolves through the private DNS chain to the private endpoint address.
7. Test TCP 1433 and authenticate using the intended SQL identity.
8. Only after dependencies are validated, consider disabling public network access.

Do not connect to the private IP or use the `<server>.privatelink.database.windows.net` name as the SQL connection string. Microsoft requires the normal `<server>.database.windows.net` FQDN for SQL gateway routing.

Reference: [Azure Private Link for Azure SQL Database](https://learn.microsoft.com/azure/azure-sql/database/private-endpoint-overview).
