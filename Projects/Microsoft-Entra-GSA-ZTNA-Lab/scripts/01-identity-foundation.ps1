# Reference scaffold for a disposable lab DC01. Review before use.
# Do not embed real passwords in source control.
$DomainDN = "DC=labcorp,DC=local"
$BaseOU = "OU=LabCorp,$DomainDN"
$OUs = @("Users","Groups","Servers","Workstations")

if (-not (Get-ADOrganizationalUnit -LDAPFilter "(distinguishedName=$BaseOU)" -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "LabCorp" -Path $DomainDN -ProtectedFromAccidentalDeletion $true
}
foreach ($Name in $OUs) {
    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$Name)" -SearchBase $BaseOU -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $Name -Path $BaseOU -ProtectedFromAccidentalDeletion $true
    }
}
$GroupsOU = "OU=Groups,$BaseOU"
$UsersOU = "OU=Users,$BaseOU"
if (-not (Get-ADGroup -Identity "IT-Admins" -ErrorAction SilentlyContinue)) {
    New-ADGroup -Name "IT-Admins" -SamAccountName "IT-Admins" -GroupScope Global -GroupCategory Security -Path $GroupsOU
}
$Password = Read-Host "Enter a lab-only password for the test account" -AsSecureString
if (-not (Get-ADUser -Identity "labadmin" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name "Lab Admin" -GivenName "Lab" -Surname "Admin" -SamAccountName "labadmin" -UserPrincipalName "labadmin@labcorp.local" -Path $UsersOU -AccountPassword $Password -Enabled $true
}
