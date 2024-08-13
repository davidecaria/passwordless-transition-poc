# Passwordless Transition - Proof of Concept

This repository offers a comprehensive overview of the passwordless transition process. It focuses on a Proof of Concept developed during an internship at Microsoft, aiming to serve as a reference for future implementations and migrations towards passwordless authentication in Azure.

It is important to note that this deployment is a simplified version of a test environment with additional resources and configurations. Passwords, usernames, and ports are placeholders and should be changed before deploying the demo.

## Reproduce the PoC

After cloning the repository the following actions should be performed in order to fully reproduce the demo environment

### Setting up the infrastructure

1. Create a **config.json** file in the **sql-infra** folder and fill it your values for:


    {
        "subscriptionId": "sub_id",
        "maintenanceConfigurationId": "/subscriptions/sub_id/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_Default",
        "adminLogin": "admin@your_domain.com",
        "adminSID": "admin_sid",
        "tenantId": "tenant_id",
        "clientIpValue": "your_id",
        "privateEndpointDnsRecordUniqueId":"unique_id1",
        "privateEndpointNestedTemplateId":"unique_id2",
        "administratorLoginPassword":"strong_password"
    }

2. Fill the logic apps **template.json** and **parameters.json** file with your subscription ID 

3. Run the **main-infra.sh** to reproduce the following architecture:

![alt text](./images/infra-deployment-passwordless-transition-poc.png "Complete infrastructure deployment")

