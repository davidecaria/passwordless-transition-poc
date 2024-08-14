Install-module Microsoft.Graph

Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Define groups
$group1 = @{
    description="Group to host uncommitted users"
    displayName="pt-uncommitted-group"
    mailEnabled=$false
    securityEnabled=$true
    mailNickname="pt-uncommitted-group"
}

$group2 = @{
    description="Group to host staged users"
    displayName="pt-staging-group"
    mailEnabled=$false
    securityEnabled=$true
    mailNickname="pt-staging-group"
}

$group3 = @{
    description="Group to host committed users"
    displayName="pt-committed-group"
    mailEnabled=$false
    securityEnabled=$true
    mailNickname="pt-committed-group"
}

# Create groups
New-MgGroup @group1
New-MgGroup @group2
New-MgGroup @group3

# Get information about the groups
Get-MgGroup -Filter "DisplayName eq 'pt-uncommitted-group'"
Get-MgGroup -Filter "DisplayName eq 'pt-uncommitted-group'"
Get-MgGroup -Filter "DisplayName eq 'pt-uncommitted-group'"