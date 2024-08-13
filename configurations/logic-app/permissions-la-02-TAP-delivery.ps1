$TenantID="<tenant_id>"

$GraphAppId = "00000003-0000-0000-c000-000000000000"

$DisplayNameOfMSI="pt-la-02-TAPissuer"

# List of permissions to assign
$PermissionNames = @(
    "GroupMember.Read.All",
    "UserAuthenticationMethod.ReadWrite.All"
)

Connect-AzureAD -TenantId $TenantID

$MSI = Get-AzureADServicePrincipal -Filter "displayName eq '$DisplayNameOfMSI'"

Start-Sleep -Seconds 5

$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$GraphAppId'"

# Loop through each permission and assign it
foreach ($PermissionName in $PermissionNames) {
    $AppRole = $GraphServicePrincipal.AppRoles | Where-Object {
        $_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application"
    }

    if ($AppRole -ne $null) {
        New-AzureAdServiceAppRoleAssignment -ObjectId $MSI.ObjectId -PrincipalId $MSI.ObjectId -ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id
        Write-Host "Assigned permission '$PermissionName' successfully."
    } else {
        Write-Host "Permission '$PermissionName' not found."
    }
}
