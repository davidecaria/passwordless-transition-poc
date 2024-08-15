# Passwordless Transition - Proof of Concept

This repository offers a comprehensive overview of the passwordless transition process. It focuses on a Proof of Concept developed during an internship at Microsoft, aiming to serve as a reference for future implementations and migrations towards passwordless authentication in Azure.

It is important to note that this deployment is a simplified version of a test environment with additional resources and configurations. Passwords, usernames, and ports are placeholders and should be changed before deploying the demo.

## 1. Reproduce the PoC

After cloning the repository the following actions should be performed in order to fully reproduce the demo environment. The objective is to follow a step by step procedure that allows to reproduce the same exact setup used for the project. The architecture is not a copy of the production one and it is designed to have the minimum elements to proceed in the transition.

### 1.1 Setting up the infrastructure

To lay the ground for the upcoming implementation, we need a complete infrastructure that will be configured and setup later. Specifically, we need three logic apps, one sql server and one sql database that runs on it, one virtual machine and a properly configured network environment.

#### Step 1
Create a **config.json** file in the **sql-infra** folder and fill it your values for:

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

#### Step 2
Fill the logic apps **template.json** and **parameters.json** file with your subscription ID 

#### Step 3
Run the **main-infra.sh** to reproduce the following architecture:

![alt text](./images/infra-deployment-passwordless-transition-poc.png "Complete infrastructure deployment")

### 1.2 Assign proper permissions and finalize configuration

To complete the infrastructure setup, we need to configure the logic apps and sql server to have the right permissions and connections. Logic apps will interact with Entra ID users and will log operations in the sql database. 

Logic apps are similar to users and groups for Entra ID, meaning that we can assign permissions to roles to each one of them. As they deliver different function, their permissions are specific to the single workload. 

The SQL Database needs to be configured to host data in the proper format and allow secure connections with the logic apps.

#### Step 1
Verify the presence of the logic apps in the **Enterprise application** menu in the Entra ID portal. They should look like this:

![alt text](./images/enterprise-app-registration.png "Enterprise application registration")

#### Step 2
Modify with the correct TenantID and run the powershell scripts: permissions-la-01-staging-users.ps1, permissions-la-02-TAP-delivery.ps1, permissions-la-03-committing-users.ps1.

#### Step 3
Review in the portal the correct assignment of the permissions and roles. In case of errors, refer to the specific powershell script in the "tools" folder.

#### Step 4
To complete the SQL setup, connect to the main database and run the scripts on **sql** folder of the **configuration**.

#### Step 5
Configure the required Entra ID groups for the following unit. A demo example is provided as **groups-setup.ps1**.

### 1.3 Configure the transition management unit (TMU)

To properly setup the logic to transition the users to passwordless authentication we have to create a workflow for each logic app. The workflows hold the code to act on the users, groups, log information and external connections.

#### Step 1
Set up each logic app with a stateful workflow. In Azure, it looks as follows:

![alt text](./images/pt-la-01-workflow-creation.png "Stateful workflow creation")

#### Step 2
Insert in each workflow code space, the proper script contained in the **transition-management** folder. Follow the numbering in the folder, Logic app 1 has to hold the code of the first workflow and so on.

#### Step 3
Add to the logic app the preferred connection type to the database. For this demo environment a standard connection string to the SQL database will be enough. The modules are found in each workflow folder. The **runAfter** section of the json shows the suggested position of the code snippet, however, it is not mandatory and it can be changed as needed. 

The configuration of the SQL connection in the logic app should look as follows:

![alt text](./images/pt-la-01-sqlcon-setup.png "SQL Database connection setup")

The connection method can be chosen, for this example, the connection string retried in the sql database page will work.

```
Server=tcp:pt-azuresqlserver.database.windows.net,1433;Initial Catalog=pt-azuresqldatabase-log;Persist Security Info=False;User ID=azuresqlserver-admin;Password={your_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;
```

If not previously configured, the logic app will not have direct access to the database. This is because the firewall on the SQL server denies connections from unknown ips by default. We can see this behavior in action as follows:

![alt text](./images/pt-la-01-sqlcon-setup2.png "SQL Database connection setup")

It is sufficient to insert the displayed IP address in the networking blade of the SQL server. Alternatively, it is possible to set up an exception for Azure services and resources coming from the same subscription.

#### Step 4
Finally, if needed, setup the notification service via email. Each workflow folder contains the necessary code to be added to the main code base, in this PoC only the second and third logic app leverage email communication. Make sure to deploy a **communication service** that copes with your communication needs.

### 1.4 Configure the device management unit (DMU)

To properly setup the DMU component, we need to configure the devices and ship a detection script to each machine.

#### Step 1
As a first step, it may be useful to automatically enroll devices in Intune. Every machine that join the Azure Active Directory will be eligible for the deployment of the scripts. In Intune, it should look as follows:

![alt text](./images/automatic-entrollment.png "Intune automatic enrolment")

#### Step 2
Build an **.intunewin** file that represents the Win32 app file for our demo. This file will include the following elements:

- detection script
- install script
- uninstall script
- session-logoff task
- key-presence-detector script

Before building the Intune package, the best option is to compile the key-presence-detector.ps1 into an executable file for the specific operating system that will receive it. 
Subsequently, with the use of the official Microsoft Tool, is is possible to package the files into a **.intunewin**.

[Microsoft Win32 Content Prep Tool](https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool)


#### Step 3
Upload the Win32 app to Intune and set the relevant properties as follows:

- Source file: your_file.intunewin
- Install command: powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -NonInteractive -File .\install.ps1
- Uninstall command: powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -NonInteractive -File .\uninstall.ps1
- Installation time required: 3 minutes
- Install behavior: System
- Operating system architecture: x86,x64
