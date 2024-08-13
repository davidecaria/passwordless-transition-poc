
--Create login for logic app fromUncommittedToStaged

CREATE LOGIN writeOnlyLogicAppFUTSLogin WITH password='AC4gCjN1cMXxo1jvbWrC'; --dummy value

CREATE USER writeOnlyLogicAppFUTSUser FROM LOGIN writeOnlyLogicAppFUTSLogin;

EXEC sp_addrolemember 'db_datawriter', 'writeOnlyLogicAppFUTSUser';


--Create login for logic app TAPdelivery

CREATE LOGIN writeOnlyLogicAppTAPLogin WITH password='AC4gCjN1cMXxo1jvbWrC'; --dummy value

CREATE USER writeOnlyLogicAppTAPLogin FROM LOGIN writeOnlyLogicAppTAPLogin;

EXEC sp_addrolemember 'db_datawriter', 'writeOnlyLogicAppTAPLogin';




